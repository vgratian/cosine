#!/bin/bash

program="Cosine Similarity Benchmarker"
bin=`basename $0`
lib="lib"
path=$(pwd)

Help() {

    cat <<EOF_PRINT_HELP

    $bin - $program

    usage:

      $./$bin [options] [-l PROJECT_1,PROJECT_2,...,PROJECT_N] FROM TO STEP REPEAT

    options:
        -s          Save results as .tsv files
        -p          Draw a graph (requires gnuplot)
        -k          Don't remove compiled binaries after tests are done
        -l          Test only these package(s) (default: all in $lib)
        -h          Print this message 

    FROM            Initial size of vectors
    TO              Final size of vectors
    STEP            Increment size of vectors after each iteration
    REPEAT          Repeat calculation during each iteration

EOF_PRINT_HELP
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Read CLI arguments 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a projects_raw
plot=false
save=false
cleanup=true

while getopts hpskl: x; do
    case "$x" in
        h) Help; exit 0 ;;
        l) projects_raw=($(sed 's/,/ /g' <<< $OPTARG)) ;;
        p) plot=true ;;
        s) save=true ;;
        k) cleanup=false ;;
        ?) exit 1 ;;
    esac
done

from=${@:$OPTIND:1}
to=${@:$OPTIND+1:1}
step=${@:$OPTIND+2:1}
repeat=${@:$OPTIND+3:1}

if [ "$from" == "" ] || [ "$to" == "" ] || [ "$step" == "" ] || ["$repeat" == ""]; then
    echo "not enough arguments, aborting"
    exit 1
fi

benchmark=$(date +%N);
printf "Starting Benchmark #$benchmark\n"
printf "with parameters: FROM=%s TO=%s STEP=%s REPEAT=%s\n" $from $to $step $repeat

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Compile utils

cd util
printf "Compiling utils..."
make
if [ $? -eq 0 ]; then
    echo " OK"
else
    echo "FAIL, aborting"
    cd ../
    exit 1
fi
cd ../

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check if projects exist in "lib/"

declare -a projects

if [ ${#projects_raw[@]} -eq 0 ]; then
    projects=($(ls $lib))
    echo "Verifying ${#projects[@]} projects..."
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# arrays to store performance results

declare -a avg_walltime
declare -a total_cputime
declare -a max_rss

avg_walltime[0]="N"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Validate/compile selected projects

declare -a projects
for project in ${projects[@]}; do
    if [ -f "$lib/$project/Makefile" ]; then
        printf " %s: compiling... " $project
        cd "$lib/$project"
        make > /dev/null 2>&1
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

    ./util/randvect.py $from -10 10 > v1
    ./util/randvect.py $from -10 10 > v2

    for project in ${projects[@]}; do
        
        printf "%20s      " $project

        cd "$lib/$project"
        
        output=($(../../util/measure ./main $repeat $from ../../v1 ../../v2))

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
# Safe results to '.csv' files

printf "\n\n"

if [ $save == true ]; then

    if [ ! -d "results" ]; then
        mkdir results
    fi

    echo "saving results..."
    
    filepath1=$(printf "results/%s_avg_walltime.csv" "$benchmark")
    printf "%s\n" "${avg_walltime[@]}" > "$filepath1"
    printf " [%s]\n" $filepath1

    filepath2=$(printf "results/%s_total_cputime.csv" "$benchmark")
    printf "%s\n" "${total_cputime[@]}" > "$filepath2"
    printf " [%s]\n" $filepath2

    filepath3=$(printf "results/%s_max_rss.csv" "$benchmark")
    printf "%s\n" "${max_rss[@]}" > "$filepath3"
    printf " [%s]\n" $filepath3


    if [ $plot == true ]; then
        gnuplot -e "benchmark='$benchmark';file1='$filepath1';file2='$filepath2';file3='$filepath3';myterm='qt'" util/multiplot.gp -persist

        if [ $? != 0 ]; then
            echo "Failed creating plot, command was:"
        fi
    fi

else
    echo "Results not saved"
fi

printf "\n"

if [ $cleanup == true ]; then
    printf "cleaning up..."
    rm v1 v2
    cd util
    make clean
    cd ../$lib
    for project in ${projects_compiled[@]}; do
        cd "$project"
        make clean
        cd ../
    done
    cd ../
    echo " DONE"
fi

echo "DONE"

