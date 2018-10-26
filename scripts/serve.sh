ABS_PATH=$(pwd)
PATH_CONFIG=$ABS_PATH/.docs
# Positional
PATH_SERVE=${1-"$ABS_PATH/tmp"} #path to build directory

$PATH_CONFIG/node_modules/.bin/gitbook serve $PATH_SERVE/gitbook
