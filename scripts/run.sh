#!/bin/bash
ROOT=$(dirname $0)/../..
cd ${ROOT}
./cmake/scripts/build.sh ${1}
cd bin
echo
echo "==================== run ====================="
echo
./${1}