ABS_PATH=$(pwd)
PATH_BUILD=${1-"$ABS_PATH/docs-build"}

VERSION=$(git describe --abbrev=0 --tags)
VERSION=${VERSION:1}

cp -a $PATH_BUILD/gitbook/_book/. .

git clean -fx $PATH_BUILD
