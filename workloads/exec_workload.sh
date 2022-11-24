#!/bin/bash
####### Configuration Parameters #######
# Paths
home=$ROCKSDB_DIRECTORY
executable_dir=$home/build
mountpoint=$home
db_dir=$mountpoint/test/kvstore
results_dir=$home/test/results

# Setup Variables
threads=(1 2 4 8 16)
ops=$DB_BENCH_OPS
keysize=8
valuesize=1024
background_flushes=1
background_compactions=7
stats_interval=1

# Check and print configurations
# -- $1: workload name
# -- $2: filename for storing the workload results
function check_and_print_configs {
    if [[ -z "${ROCKSDB_DIRECTORY}" ]]; then
        echo "ROCKSDB_DIRECTORY is not set"
        exit 1
    fi

    if [[ -z "${DB_BENCH_OPS}" ]]; then
        echo "DB_BENCH_OPS is not set"
        echo "Setting ops to default value of 1000000000"
        ops=1000000000
    fi

    mkdir -p $db_dir
    mkdir -p $results_dir

    echo -e "Executing $1 workload ..."
    echo -e "\t- Number of threads: $threads"
    echo -e "\t- Number of operations: $ops"
    echo -e "\t- Key size: $keysize"
    echo -e "\t- Value size: $valuesize"
    echo -e "\t- Background flushes: $background_flushes"
    echo -e "\t -Background compactions: $background_compactions"
    echo -e "\t- Stats interval: $stats_interval"
    echo -e "\t- Results path: $results_dir/$2"
}

####### Workloads #######
# fillrandom workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function fillrandom {
    check_and_print_configs "fillrandom" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=fillrandom \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                &> $results_dir/$4
    echo "Workload done!"
}

####### Workloads #######
# YCSBWorkloadA workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function ycsbwklda {
    check_and_print_configs "ycsbwklda" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=ycsbwklda \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                --use_existing_db=true \
                &> $results_dir/$4
    echo "Workload done!"
}

# fillseq workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function fillseq {
    check_and_print_configs "fillseq" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=fillseq \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                &> $results_dir/$4
    echo "Workload done!"
}
# readrandom workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function readrandom {
    check_and_print_configs "readrandom" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=readrandom \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --use_existing_db=1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                &> $results_dir/$4
    echo "Workload done!"
}
# seekrandom workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function seekrandom {
    check_and_print_configs "seekrandom" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=seekrandom \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --seek_nexts=50 \
                --use_existing_db=1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                &> $results_dir/$4
    echo "Workload done!"
}
# deleterandom workload
# -- $1: threads
# -- $2: key size in bytes
# -- $3: value size in bytes
# -- $4: filename for storing the workload results
function deleterandom {
    check_and_print_configs "deleterandom" "$4"
    cd $executable_dir
    /usr/bin/time --verbose --output $results_dir/$4-time -- ./db_bench  --benchmarks=deleterandom \
                --db=$db_dir \
                --num=$((ops / $1)) \
                --key_size=$2 \
                --value_size=$3 \
                --threads=$1 \
                --use_existing_db=1 \
                --compression_type="none" \
                --histogram=true \
                --stats_interval_seconds=$stats_interval \
                --max_background_flushes=$background_flushes \
                --max_background_compactions=$background_compactions \
                &> $results_dir/$4
    echo "Workload done!"
}

"$@"