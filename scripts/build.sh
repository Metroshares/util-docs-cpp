# If there are implementation issues due to non-compliance of patterns, pass in relative paths (from root of typescript project) as positionals.

ABS_PATH=$(pwd)
# Positionals
PATH_CONFIG=${1-"$ABS_PATH/.docs"} #path to docs directory
PATH_BUILD=${2-"$ABS_PATH/tmp"} #path to build directory

PATH_TD_BUILD=$PATH_BUILD
PATH_STATIC="$ABS_PATH/docs"

if [ -d "$PATH_BUILD" ]; then
  ## copy static files into gitbook before
  read -p "Preparing build, sure you want to rm -fr $PATH_BUILD? (press enter, or alt+c to cancel)" -n 1 -r
  rm -fr $PATH_BUILD
fi

mkdir $PATH_BUILD
mkrdir $PATH_BUILD/gitbook

cp SUMMARY.md $PATH_BUILD/gitbook/SUMMARY.md
cp README.md $PATH_BUILD/gitbook/README.md

{
  doxygen &&
  python3 -m venv ~/.virtualenvs/myvenv
  source ~/.virtualenvs/myvenv/bin/activate
  which python
  doxybook -i $PATH_BUILD/xml -o $PATH_BUILD/gitbook -s $PATH_BUILD/gitbook/SUMMARY.md -t gitbook
  deactivate
} || {
  echo "Doxygen or Doxybook was not installed. Install both and try again. Exiting now."
  exit
}

if [ -d "$PATH_STATIC" ]; then
  ## copy static files into gitbook before
  echo "copying static files"
  cp -a $PATH_STATIC/. $PATH_BUILD/static
fi

#copy book.json into new build directory
cp $PATH_CONFIG/book.json $PATH_TD_BUILD/book.json
#copy style overrides into new build directory
cp -R $PATH_CONFIG/theme/styles $PATH_TD_BUILD/styles
#copy layout overrides into new build directory
cp -R $PATH_CONFIG/theme/layout $PATH_TD_BUILD/layout
#copy images into new build directory
cp -R $PATH_CONFIG/theme/images $PATH_TD_BUILD/images
#copy images into new build directory

{
  #run gitbook install/build
  $PATH_CONFIG/node_modules/.bin/gitbook install $PATH_TD_BUILD
  $PATH_CONFIG/node_modules/.bin/gitbook build $PATH_TD_BUILD
} || {
  echo "Gitbook does not appear to be installed, try 'npm run docs:init'"
  exit
}

# cp $PATH_CONFIG/theme/index.html ./index.html

# git clean -fx $PATH_BUILD
