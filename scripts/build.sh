# If there are implementation issues due to non-compliance of patterns, pass in relative paths (from root of typescript project) as positionals.

ABS_PATH=$(pwd)
# Positionals
# _VERSION_MANUAL=${1}

PATH_CONFIG=${2-"$ABS_PATH/.docs"}
PATH_BUILD=${3-"$ABS_PATH/tmp"}

PATH_OUTPUT="docs"

PATH_STATIC="$ABS_PATH/docs"

# if [ -z "$_VERSION_MANUAL" ]; then
  _VERSION=$(git describe --abbrev=0 --tags)
  VERSION=${_VERSION:1}
# else
  # VERSION=$_VERSION_MANUAL
# fi;

echo "VERSION: $VERSION"

if [ -z "$VERSION" ]; then
  echo "Version must be set."
  exit
fi;

if [ ! -d "$PATH_OUTPUT" ]; then
  mkdir $PATH_OUTPUT
fi

if [ ! -d "$PATH_OUTPUT/history" ]; then
  mkdir $PATH_OUTPUT/history
fi

if [ ! -d "$PATH_OUTPUT/history/$VERSION" ]; then
  mkdir $PATH_OUTPUT/history/$VERSION
fi

node .docs/versions.js -p $PATH_OUTPUT/history

# echo "Checking out tag $VERSION"
# {
#   git fetch --all --tags --prune
#   git checkout tags/v$VERSION
# } || {
#   echo "Something went wrong while checking out the version."
#   exit
# }

if [ -d "$PATH_BUILD" ]; then
  ## copy static files into gitbook before
  read -p "Preparing build, sure you want to rm -fr $PATH_BUILD? (press enter, or alt+c to cancel)" -n 1 -r
  rm -fr $PATH_BUILD
fi

mkdir $PATH_BUILD
mkdir $PATH_BUILD/gitbook

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

doxybook -i $PATH_BUILD/xml -o $PATH_BUILD/gitbook -s SUMMARY.md -t gitbook

if $PY_VENV; then
  echo "Deactivating python3 virtual environment."
  deactivate
fi

if [ -d "$PATH_STATIC" ]; then
  echo "Static Directory found."
#Add files to summary
  line=1
  summary="$ABS_PATH/SUMMARY.md"

  sed -i.bak '1i\
  * [Readme]( README.md )\
  * [License]( LICENSE.md )\
  ' $summary

  let line+=2
  for d in $PATH_STATIC/*
  do
    echo "Directory Found: $d"
    if [ -d "$f" ]
    then
      echo "Index exists for directory."
    else
      cat "# $(echo ${d##/*/})" > $PATH_STATIC/${d##/*/}/index.md
    fi
    for f in $d/*.md; do
      let line+=1
      echo "File Found: $f"
      let line+=1
      filename=$(echo ${f##/*/})
      prettyname=${filename//-/$'\n'}
      prettyname=${prettyname//.md/$'\n'}
      cat "* [$prettyname]($f)" >> $d/index.md
      sed -i.bak ''"$line"'i\
        * ['"$( echo $prettyname )"']('"$( echo $d/${f##/*/})"')\
      ' $summary
    done
  done

  sed -i.bak ''"$line"'i\
  ' $summary

  cp -R $PATH_STATIC/. $PATH_BUILD/static
fi

cp SUMMARY.md $PATH_BUILD/gitbook/SUMMARY.md
cp README.md $PATH_BUILD/gitbook/README.md
cp LICENSE.md $PATH_BUILD/gitbook/LICENSE.md

node .docs/config.js

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

cp -R $PATH_BUILD/gitbook/. $PATH_OUTPUT/history/$VERSION

touch ./.nojekyll
# cp $PATH_CONFIG/theme/index.html ./index.html
# git clean -fx $PATH_BUILD
