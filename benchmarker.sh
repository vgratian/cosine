#!/bin/bash

project="Cosine Similarity Benchmarker"
bin=`basename $0`
projects_dir="lib"

Help() {

    cat <<EOF_PRINT_HELP

    $project - $bin

    usage:

      $./$bin [options] [-p PROJECT_1,PROJECT_2,...,PROJECT_N] FROM TO STEP

    options:
        -d          Draw a graph (requires matplotlib)
        -s          Save results to "results/"
        -k          Don't remove compiled binaries after tests are done
        -p          Test only these project(s) (default: all projects in $projects_dir)

    FROM            Start with vectors of this size, if the next two arguments
                    are not provided, then only one test is done
    TOX             Run tests and end with vectors of this size
    STEP            Increment size of vectors during each test

EOF_PRINT_HELP
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Read CLI arguments 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a projects_raw
draw_graph=false
save_result=false
keep_bins=false

while getopts hdsp: x; do
    case "$x" in
        h) Help; exit 0 ;;
        p) projects_raw=($(sed 's/,/ /g' <<< $OPTARG)) ;;
        d) draw_graph=true ;;
        s) save_result=true ;;
        k) keep_bins=true ;;
        ?) exit 1 ;;
    esac
done

size_min=${@:$OPTIND:1}
size_max=${@:$OPTIND+1:1}
step=${@:$OPTIND+2:1}

printf "\n"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Validate projects in "lib/"
# compile if needed
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

declare -a projects

if [ ${#projects_raw[@]} -eq 0 ]; then
    projects=($(ls $projects_dir))
    echo "verifying ${#projects[@]} projects..."
else
    for p in ${projects_raw[@]}; do
        if [ -d "$projects_dir/$p" ]; then
            projects+=($p)
            echo "ok: $p"
        else
            echo "invalid project: $p; \"$projects_dir/$p\" not found, skipped"
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
declare -a results

results[0]="N "

for project in ${projects[@]}; do
    if [ -f "$projects_dir/$project/Makefile" ]; then
        printf " %s: compiling... " $project
        cd "$projects_dir/$project"
        make
        if [ $? -eq 0 ]; then
            if [ -f "main" ]; then
                printf "OK\n"
                projects_compiled+=($project)
                projects_ok+=($project)
                results[0]="${results[0]} $project"
            else
                echo "OK but executable \"main\" not found, SKIP"
            fi
        else
            echo "FAIL, SKIP"
        fi
        cd "../../"
    else
        if [ -f "$projects_dir/$project/main" ]; then
            echo " $project: executable \"main\" found OK"
            projects_ok+=($project)
            results[0]="${results[0]} $project"
        else
            echo " $project: Makefile or \"main\" not present, SKIP"
        fi
    fi
done


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run the benchmark
# Show results on the screen
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

printf "\n\n"

declare -a output
i=1
repeat=10
for ((; $size_min <= $size_max; size_min+=$step)); do

    results[i]="$size_min"

    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    printf "N=%7s R=%7s\n" $size_min $repeat

    printf "%30s %30s %30s %30s\n" "PROJECT" "RESULT" "AVG TIME" "ELAPSED TIME"

    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    ./rand_vector.py $size_min > v1
    ./rand_vector.py $size_min > v2

    for project in ${projects[@]}; do
        
        printf "%30s " $project

        cd "$projects_dir/$project"
        
        start=$(date +%s.%N)
        output=($(./main 10 $size_min ../../v1 ../../v2))
        end=$(date +%s.%N)

        similarity=${output[0]}
        avg_time=${output[1]}
        elapsed_time="$(bc <<< "$end-$start")"

        printf "%30s %30s %30s\n" $similarity $avg_time $elapsed_time

        #echo "start=$start end=$end similarity=$similarity avg_time=$avg_time"
    
        results[i]+=" $avg_time"

        cd ../../
    done
    i+=1
done

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Safe results to text file and graph
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

printf "\n\n"
output_prefix=$(date +%N);
echo "writing results to file [$output_prefix.txt]"
printf "%s\n" "${results[@]}" > $output_prefix.txt

echo "drawing graph... [$output_prefix.png]"
./draw_graph.py $output_prefix.txt $output_prefix

printf "\n\n"
printf "cleaning up... "

cd "$projects_dir"
for project in ${projects_compiled[@]}; do
    cd "$project"
    make clean
    cd ../
done
cd ../

printf "Done\n"
