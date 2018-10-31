ABS_PATH=$(pwd)
PATH_CONFIG=$ABS_PATH/.docs
# Positional

PATH_OUTPUT="docs"

VERSION=$(git describe --tags)
VERSION=${VERSION:1}

PATH_SERVE=$PATH_OUTPUT/history/$VERSION #path to build directory

echo "Serving $VERSION from $PATH_SERVE"

$PATH_CONFIG/node_modules/.bin/gitbook serve $PATH_SERVE
