#!/bin/bash
ARG=2
while [ $ARG -lt 1048577 ]; do
    echo "Input is $ARG"
    ./fft $ARG 4
    ./fft $ARG 3
    let ARG=ARG*2
done
