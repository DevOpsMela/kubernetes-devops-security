#!/bin/bash
#cis-master.sh

total_fail=$(./root/kube-bench run -s master  --version 1.15 --check 1.2.20 --json | jq '.Controls[].total_fail')

if [[ "$total_fail" -ne 0 ]];
        then
                echo "CIS Benchmark Failed MASTER while testing for 1.2.20"
                exit 1;
        else
                echo "CIS Benchmark Passed for MASTER - 1.2.20"
fi;
