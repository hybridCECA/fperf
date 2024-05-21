#!/bin/bash

test () {
	echo "starting test for leaf spine $1 $2 --------------" >> timing_data.txt
	sed -i "s/int leaf_cnt.*/int leaf_cnt = $1;/" src/tests.cpp
	sed -i "s/int spine_cnt.*/int spine_cnt = $2;/" src/tests.cpp
	make
	sleep 5
	for i in {1..3}
	do
		bash -c "time ./build/fperf leaf_spine_bw" &>> timing_data.txt
	done
}

test 3 2
test 4 2
test 3 3
test 5 2
test 4 3
test 5 3