#!/bin/bash

program="Cosine Similarity Benchmarker"
bin=`basename $0`
lib="lib"
path=$(pwd)

Help() {

    cat <<EOF_PRINT_HELP

    $bin - $program

    usage:

      $./$bin [options] [-p PROJECT_1,PROJECT_2,...,PROJECT_N] FROM TO STEP

    options:
        -d          Draw a graph (requires matplotlib)
        -s          Save results to "results/"
        -k          Don't remove compiled binaries after tests are done
        -p          Test only these project(s) (default: all projects in $lib)

    FROM            Start with vectors of this size, if the next two arguments
                    are not provided, then only one test is done
    TO              Run tests and end with vectors of this size
    STEP            Increment size of vectors during each test

EOF_PRINT_HELP
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Read CLI arguments 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a projects_raw
draw_graphs=false
save_results=false
no_cleanup=false

while getopts hdskp: x; do
    case "$x" in
        h) Help; exit 0 ;;
        p) projects_raw=($(sed 's/,/ /g' <<< $OPTARG)) ;;
        d) draw_graphs=true ;;
        s) save_results=true ;;
        k) no_cleanup=true ;;
        ?) exit 1 ;;
    esac
done

from=${@:$OPTIND:1}
to=${@:$OPTIND+1:1}
step=${@:$OPTIND+2:1}
repeat=100

if [ "$from" == "" ] || [ "$to" == "" ] || [ "$step" == "" ]; then
    echo "not enough arguments, aborting"
    exit 1
fi

printf "benchmark parameters: FROM=%s TO=%s STEP=%s REPEAT=%s\n" $from $to $step $repeat

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Validate projects in "lib/"
# compile if needed
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd measure
make
if [ $? -eq 0 ]; then
    echo "OK compiled \"measure\""
else
    echo "failed to compile make, aborting"
    exit 1
fi
cd ../


declare -a projects

if [ ${#projects_raw[@]} -eq 0 ]; then
    projects=($(ls $lib))
    echo "verifying ${#projects[@]} projects..."
else
    for p in ${projects_raw[@]}; do
        if [ -d "$lib/$p" ]; then
            projects+=($p)
            echo "ok: $p"
        else
            echo "invalid project: $p; \"$lib/$p\" not found, skipped"
        fi
    done
    echo "verifying selected ${#projects[@]} projects..."
fi

if [ ${#projects[@]} -eq 0 ]; then
    echo "no valid projects defined, aborting"
    exit 1
fi

declare -a projects_compiled
declare -a projects_ok

# arrays to keep performance results
declare -a avg_walltime
declare -a total_cputime
declare -a max_rss

avg_walltime[0]="N"

for project in ${projects[@]}; do
    if [ -f "$lib/$project/Makefile" ]; then
        printf " %s: compiling... " $project
        cd "$lib/$project"
        make
        if [ $? -eq 0 ]; then
            if [ -f "main" ]; then
                printf "OK\n"
                projects_compiled+=($project)
                projects_ok+=($project)
                avg_walltime[0]+=",$project"
            else
                echo "OK but executable \"main\" not found, SKIP"
            fi
        else
            echo "FAIL, SKIP"
        fi
        cd "../../"
    else
        if [ -f "$lib/$project/main" ]; then
            echo " $project: executable \"main\" found OK"
            projects_ok+=($project)
            avg_walltime[0]+=",$project"
        else
            echo " $project: Makefile or \"main\" not present, SKIP"
        fi
    fi
done

total_cputime[0]="${avg_walltime[0]}"
max_rss[0]="${avg_walltime[0]}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run the benchmark
# Show results on the screen
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

printf "\n\n"

declare -a output
i=1
for ((; $from <= $to; from+=$step)); do

    avg_walltime[i]="$from"
    total_cputime[i]="$from"
    max_rss[i]="$from"

    printf "\nn = %s\n" $from
    printf "++++++++++++++++++++      +++++++++++++++++++++++++++++  +++++++++++++++++++++++++++++  "
    printf "+++++++++++++++++++  +++++++++++++++++++  ++++++++++++++  +++++++++++++++\n"
    printf "%20s      %-30s %-30s " "PROJECT" "RESULT" "AVG WALLTIME PER CALC"
    printf "%-20s %-20s %-15s %15s\n" "CPU TIME" "CPUTIME USER" "CPUTIME SYS" "MAX RSS (KB)"
    printf "++++++++++++++++++++      +++++++++++++++++++++++++++++  +++++++++++++++++++++++++++++  "
    printf "+++++++++++++++++++  +++++++++++++++++++  ++++++++++++++  +++++++++++++++\n"

    ./util/rand_vector.py $from > v1
    ./util/rand_vector.py $from > v2

    for project in ${projects[@]}; do
        
        printf "%20s      " $project

        cd "$lib/$project"
        
        output=($(../../measure/measure ./main $repeat $from ../../v1 ../../v2))

        if [ ! $? -eq 0 ]; then
            echo "something went wrong, ABORTING."
            cd ../../
            save_results=false
            draw_graphs=false
            break
        fi

        similarity=${output[0]}
        wall_time=${output[1]}
        cpu_total=${output[2]}
        cpu_user=${output[3]}
        cpu_sys=${output[4]}
        rss=${output[5]}

        printf "%-30s %-30s %-20s %-20s %-15s %15s\n" $similarity $wall_time $cpu_total $cpu_user $cpu_sys $rss
    
        avg_walltime[i]+=",$wall_time"
        total_cputime[i]+=",$cpu_total"
        max_rss[i]+=",$rss"

        cd ../../
    done
    i+=1
done

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Safe results to text file and graph
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

printf "\n\n"

if [ $save_results == true ]; then

    echo "saving results..."
    
    output_prefix=$(date +%N);

    filepath=$(printf "%s_avg_walltime.csv" "$output_prefix")
    printf "%s\n" "${avg_walltime[@]}" > "$filepath"
    echo " saved avg_walltime to [$filepath]"

    filepath=$(printf "%s_total_cputime.csv" "$output_prefix")
    printf "%s\n" "${total_cputime[@]}" > "$filepath"
    echo " saved total_cputime to [$filepath]"

    filepath=$(printf "%s_max_rss.csv" "$output_prefix")
    printf "%s\n" "${max_rss[@]}" > "$filepath"
    echo " saved max_rss to [$filepath]"

else
    echo "results not saved"
fi

#echo "drawing graph... [$output_prefix.png]"
#./draw_graph.py $output_prefix.txt $output_prefix

printf "\n\n"
printf "cleaning up... \n"

rm v1 v2

if [ $no_cleanup == true ]; then
    echo "kept project binaries"
else
    cd measure
    make clean
    cd ../$lib
    for project in ${projects_compiled[@]}; do
        cd "$project"
        make clean
        cd ../
    done
    cd ../
    echo "cleaned up project binaries"
fi

echo "DONE"

