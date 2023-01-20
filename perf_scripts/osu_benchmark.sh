#!/bin/bash

module load openmpi

cd /shared/build/
wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.2.tar.gz
tar zxvf ./osu-micro-benchmarks-5.6.2.tar.gz
cd osu-micro-benchmarks-5.6.2/
./configure CC=mpicc CXX=mpicxx
 make -j 4
EOF

sh ./compile-osu.sh

