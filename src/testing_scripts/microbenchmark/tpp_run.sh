#!/bin/bash

# Enable debug mode and error checking
set -u   # Treat unset variables as errors
set -e   # Exit immediately if a command fails
set -x   # Print each command before executing it

# execute this script from project root directory
source global_dirs.sh

result_dir=${output_log_dir}/microbench_tpp
mkdir -p ${result_dir}


${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_10G.bin -frun=${compiled_package_dir}/run_zipfan_hottest_10G.bin -fout=${result_dir}/zipfan_hottest_10G.read.log --logtostderr -sleep=10 -work=2
sleep 20
${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_10G.bin -frun=${compiled_package_dir}/run_zipfan_hottest_10G.bin -fout=${result_dir}/zipfan_hottest_10G.write.log --logtostderr -sleep=10 -work=0
sleep 20

${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_13.5G.bin -frun=${compiled_package_dir}/run_zipfan_hottest_13.5G.bin -fout=${result_dir}/zipfan_hottest_13.5G.read.log --logtostderr -sleep=10 -work=2
sleep 20
${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_13.5G.bin -frun=${compiled_package_dir}/run_zipfan_hottest_13.5G.bin -fout=${result_dir}/zipfan_hottest_13.5G.write.log --logtostderr -sleep=10 -work=0
sleep 20

${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_27G.bin -frun=${compiled_package_dir}/warmup_zipfan_hottest_27G.bin -fout=${result_dir}/zipfan_hottest_27G.read.log --logtostderr -sleep=10 -work=2
sleep 20
${compiled_package_dir}/tpp_mem_access -fwarmup=${compiled_package_dir}/warmup_zipfan_hottest_27G.bin -frun=${compiled_package_dir}/warmup_zipfan_hottest_27G.bin -fout=${result_dir}/zipfan_hottest_27G.write.log --logtostderr -sleep=10 -work=0
sleep 20