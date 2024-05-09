#!/bin/bash
ROOT=$(dirname $0)/../..
cd ${ROOT}
mkdir -p build bin lib
cmake -B ./build/
if [ -z "$1" ]
then
    cmake --build ./build/
else
    cmake --build ./build/ --target $1
fi
