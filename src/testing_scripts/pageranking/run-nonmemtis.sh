#!/bin/bash

 
###### update DIR!
 
 

function func_cache_flush() {
    echo 3 | sudo tee /proc/sys/vm/drop_caches
    free
    return
}

function func_main() {
 
    TIME="/usr/bin/time"

    # make directory for run-tpp/results-pr

    
    mkdir -p ${results_DIR}/results-pr
    LOG_DIR=${results_DIR}/results-pr 
 
    # flush cache
    func_cache_flush
    sleep 2

    # Start numastat in the background to monitor memory access
    numastat -m 1 > ${LOG_DIR}/numastat.log & 
    NUMASTAT_PID=$!

	${TIME} -f "execution time %e (s)\nMax Memory (MB): %M\nAvg Resident Set Size (MB): %K" \
    ${BENCH_RUN}  2>&1 | tee ${LOG_DIR}/output_with_mem.log  

    # Kill numastat after the benchmark finishes
    kill ${NUMASTAT_PID}
}

################################ Main ##################################
# thp_setting=madvise 
 
source global_dirs.sh
bin_DIR=${compiled_package_dir}
results_DIR=${output_log_dir}/pageranking-`uname -r`
mkdir -p ${results_DIR}
BENCH_BIN=third_party/tmp/gapbs
BENCH_RUN="${BENCH_BIN}/pr  -u26 -k20 -i10 -n100"

func_main
