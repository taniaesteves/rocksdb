FROM ubuntu:20.04

ARG N_CPU=1
ENV ROCKSDB_DIRECTORY=/rocksdb
ENV DB_BENCH_OPS=100000000

# Install dependencies
RUN apt-get update -y && apt-get install -y software-properties-common
RUN apt-get install -y build-essential bc
RUN apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev cmake
RUN apt-get install -y gcc-7 g++-7 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN apt-get install -y time
# Get RocksDB source code
COPY . /rocksdb
WORKDIR /rocksdb

# Compile RocksDB
RUN mkdir -p build; cd build; cmake ..; make -j${N_CPU}

# Add exection permission to the script
RUN chmod +x workloads/exec_workload.sh

# Set exec_workload.sh as the entrypoint
ENTRYPOINT [ "/rocksdb/workloads/exec_workload.sh" ]