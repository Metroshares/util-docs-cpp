ABS_PATH=$(pwd)
PATH_BUILD=${1-"$ABS_PATH/docs-build"}

cp -a $PATH_BUILD/_book/. .
git clean -fx $PATH_BUILD
