#!/bin/bash - 
#===============================================================================
#
#          FILE:  publish.sh
# 
#         USAGE:  ./publish.sh 
# 
#   DESCRIPTION:  G
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: YOUR NAME (), 
#       COMPANY: 
#       CREATED: 28/10/14 08:57:43 PM EDT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Bash sucks at figuring itself out. Finds this script's directory. From : http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

TAG=${1:-}
if [ -z $TAG ]; then
  echo "You must specify a tag, even if it's latest"
  exit 1
fi

# Require no changes in git so the tag is meaningful
git update-index -q --ignore-submodules --refresh
err=0

if ! git diff-files --quiet --ignore-submodules --
then
    echo >&2 "cannot $1: you have unstaged changes."
    git diff-files --name-status -r --ignore-submodules -- >&2
    err=1
fi

if ! git diff-index --cached --quiet HEAD --ignore-submodules --
then
    echo >&2 "cannot $1: your index contains uncommitted changes."
    git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
    err=1
fi

if [ $err = 1 ]
then
    echo >&2 "Please commit or stash them."
    exit 1
fi

docker build -t jnijni/live-feedback:$TAG --no-cache "$DIR/.."
docker push jnijni/live-feedback:$TAG
git tag $TAG
