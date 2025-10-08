#!/bin/bash

NRT_INIT_TIME_ESTIMATE=0.1

_test_all_neuron_cores() {
    echo "Testing all neuron cores (no NEURON_RT_NUM_CORES/NEURON_RT_VISIBLE_CORES setting..."
    echo "--- NEURON environment variables ---"
    env | grep 'NEURON'
    echo "---"


    echo "=== Peek neuron cores single process ==="
    ./peek_neuron_cores
    echo "==="

    echo "=== Peek neuron cores multiple processes (only first should work) ==="
    for i in {1..4}; do
        ./peek_neuron_cores -b &
        sleep NRT_INIT_TIME_ESTIMATE
        neuron-ls -a
    done
    pkill -f peek_neuron_cores
    echo "==="
}

_test_num_neuron_cores() {
    echo "Testing NEURON_RT_NUM_CORES..."
    echo "--- NEURON environment variables ---"
    env | grep 'NEURON'
    echo "---"


    echo "=== Peek neuron cores single process ==="
    for i in {1..33}; do
        NEURON_RT_NUM_CORES=$i ./peek_neuron_cores
        sleep NRT_INIT_TIME_ESTIMATE
        neuron-ls -a
    done
    echo "==="

    echo "=== Peek neuron cores multiple processes ==="
    for i in {1..33}; do
        ./peek_neuron_cores -b &
        sleep NRT_INIT_TIME_ESTIMATE
        neuron-ls -a
    done
    pkill -f peek_neuron_cores
    echo "==="
}


_test_visible_neuron_cores() {
    echo "Testing NEURON_RT_VISIBLE_CORES..."
    echo "--- NEURON environment variables ---"
    env | grep 'NEURON'
    echo "---"

    for i in {1..33}; do
        NEURON_RT_VISIBLE_CORES=0-$i ./peek_neuron_cores
        sleep NRT_INIT_TIME_ESTIMATE
        neuron-ls -a
    done

    NEURON_RT_VISIBLE_CORES=0-1,2-3 ./peek_neuron_cores
    sleep NRT_INIT_TIME_ESTIMATE
    neuron-ls -a

    NEURON_RT_VISIBLE_CORES=0-4,2-3 ./peek_neuron_cores
    sleep NRT_INIT_TIME_ESTIMATE
    neuron-ls -a

    NEURON_RT_VISIBLE_CORES=0-4,2-3 ./peek_neuron_cores
    sleep NRT_INIT_TIME_ESTIMATE
    neuron-ls -a

}

_run_all_tests() {
    echo "--- Current NEURON environment variables ---"
    env | grep 'NEURON'
    echo "--------------------------------------------"

    pkill -f peek_neuron_cores

    _test_all_neuron_cores
    _test_num_neuron_cores
    _test_visible_neuron_cores
}

set -x
neuron-ls
neuron-ls --wide
neuron-ls --show-all-procs
neuron-ls --topology
neuron-ls -j
set +x

_run_all_tests

export NEURON_LOGICAL_NC_CONFIG=1
_run_all_tests

export NEURON_LOGICAL_NC_CONFIG=2
_run_all_tests

export NEURON_LOGICAL_NC_CONFIG=3
_run_all_tests

export NEURON_LOGICAL_NC_CONFIG=4
_run_all_tests


echo "Testing NEURON_RT_NUM_CORES jobs with different NEURON_LOGICAL_NC_CONFIG..."
echo "--- NEURON environment variables ---"
env | grep 'NEURON'
echo "---"

NEURON_LOGICAL_NC_CONFIG=1 NEURON_RT_NUM_CORES=4 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=2 NEURON_RT_NUM_CORES=4 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=3 NEURON_RT_NUM_CORES=4 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=4 NEURON_RT_NUM_CORES=4 ./peek_neuron_cores -b

echo "Testing NEURON_RT_VISIBLE_CORES jobs with different NEURON_LOGICAL_NC_CONFIG..."
echo "--- NEURON environment variables ---"
env | grep 'NEURON'
echo "---"

NEURON_LOGICAL_NC_CONFIG=1 NEURON_RT_VISIBLE_CORES=0-1 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=2 NEURON_RT_VISIBLE_CORES=2-3 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=3 NEURON_RT_VISIBLE_CORES=3-4 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=4 NEURON_RT_VISIBLE_CORES=5-6 ./peek_neuron_cores -b

echo "Testing NEURON_RT_VISIBLE_CORES jobs with different NEURON_LOGICAL_NC_CONFIG..."
echo "--- NEURON environment variables ---"
env | grep 'NEURON'
echo "---"

NEURON_LOGICAL_NC_CONFIG=1 NEURON_RT_VISIBLE_CORES=0-1 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=2 NEURON_RT_VISIBLE_CORES=1-2 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=3 NEURON_RT_VISIBLE_CORES=3-4 ./peek_neuron_cores -b
NEURON_LOGICAL_NC_CONFIG=4 NEURON_RT_VISIBLE_CORES=5-6 ./peek_neuron_cores -b



