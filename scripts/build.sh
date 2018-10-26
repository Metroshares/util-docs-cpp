# If there are implementation issues due to non-compliance of patterns, pass in relative paths (from root of typescript project) as positionals.

ABS_PATH=$(pwd)
# Positionals
PATH_CONFIG=${2-"$ABS_PATH/.docs"}
PATH_BUILD=${3-"$ABS_PATH/tmp"}

VERSION=$(git describe --tags)
VERSION=${VERSION:1}

PATH_OUTPUT="docs"

if !VERSION; then
  echo "version must be set."
fi;

PATH_STATIC="$ABS_PATH/docs"

if [ -d "$PATH_BUILD" ]; then
  ## copy static files into gitbook before
  read -p "Preparing build, sure you want to rm -fr $PATH_BUILD? (press enter, or alt+c to cancel)" -n 1 -r
  rm -fr $PATH_BUILD
fi

mkdir $PATH_BUILD
mkdir $PATH_BUILD/gitbook

cp SUMMARY.md $PATH_BUILD/gitbook/SUMMARY.md
cp README.md $PATH_BUILD/gitbook/README.md

{
  doxygen
} || {
  echo "Doxygen is not installed. Install and try again. Exiting now."
  exit

}

PY_VER=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
PY_VER_SEM=( ${PY_VER//./ } )
PY_VER_MAJOR=${PY_VER_SEM[0]}

echo $PY_VER_MAJOR

if [ "$PY_VER_MAJOR" != "3" ]; then
  echo "Python version is not 3"
  {
    PYTHON3_INSTALLED=$(python3 --version)
    echo "Python3 installed ($PYTHON3_INSTALLED)"
  } || {
    echo "Python3 not installed, please install python3"
    exit
  }
  echo "Starting python3 virtual environment."
  python3 -m venv ~/.virtualenvs/myvenv
  source ~/.virtualenvs/myvenv/bin/activate
  PY_VENV=true
fi

doxybook -i $PATH_BUILD/xml -o $PATH_BUILD/gitbook -s $PATH_BUILD/gitbook/SUMMARY.md -t gitbook

if $PY_VENV; then
  echo "Deactivating python3 virtual environment."
  deactivate
fi

if [ -d "$PATH_STATIC" ]; then
  ## copy static files into gitbook before
  echo "copying static files"
  cp -a $PATH_STATIC/. $PATH_BUILD/static
fi

#copy book.json into new build directory
cp $PATH_CONFIG/book.json $PATH_BUILD/gitbook/book.json
#copy style overrides into new build directory
cp -R $PATH_CONFIG/theme/styles $PATH_BUILD/gitbook/styles
#copy layout overrides into new build directory
cp -R $PATH_CONFIG/theme/layout $PATH_BUILD/gitbook/layout
#copy images into new build directory
cp -R $PATH_CONFIG/theme/images $PATH_BUILD/gitbook/images
#copy images into new build directory

{
  #run gitbook install/build
  $PATH_CONFIG/node_modules/.bin/gitbook install $PATH_BUILD/gitbook
  $PATH_CONFIG/node_modules/.bin/gitbook build $PATH_BUILD/gitbook
} || {
  echo "Gitbook does not appear to be installed, try 'npm run docs:init'"
  exit
}

if [ ! -d "$PATH_OUTPUT" ]; then
  mkdir $PATH_OUTPUT
fi

if [ ! -d "$PATH_OUTPUT/$VERSION" ]; then
  mkdir $PATH_OUTPUT/$VERSION
fi

cp -R $PATH_BUILD/gitbook/_book $PATH_OUTPUT/$VERSION

# cp $PATH_CONFIG/theme/index.html ./index.html

# git clean -fx $PATH_BUILD
