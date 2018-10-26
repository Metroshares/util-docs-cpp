#!/bin/bash
ABS_PATH=$(pwd)
#path to docs directory
PATH_CONFIG=${1-"$ABS_PATH/.docs"}

cd $PATH_CONFIG
npm install
