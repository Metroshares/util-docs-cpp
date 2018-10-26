#!/bin/bash
#path to PATH_CONFIG directory
PATH_CONFIG=${2-"./PATH_CONFIG"}
#path to build directory
PATH_BUILD=${3-$PATH_CONFIG/dist}

sh $PATH_DOC_UTIL/scripts/build.sh $PATH_CONFIG $PATH_BUILD
sh $PATH_DOC_UTIL/scripts/serve.sh $PATH_BUILD
