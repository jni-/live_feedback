#!/bin/bash - 
#===============================================================================
#
#          FILE:  start.sh
#
#         USAGE:  ./start.sh
#
#   DESCRIPTION:  Starts a development docker. Uses port 8080
#
#       OPTIONS:  ---
#  REQUIREMENTS:  A docker image name live_feedback. Use "docker built -t live_feedback ." after copying the proper Dockerfile.* to Dockerfile
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Jni
#       COMPANY:
#       CREATED: 19/10/14 03:55:28 PM EDT
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
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )/../src"

RSYNC="rsync --exclude=_build/ --exclude=deps/ --exclude=.git/ --exclude=_test/ --exclude=/Dockerfile* -ar --update --info=progress2"

TEST_MODE=${1:-}
if [[ "$TEST_MODE" = 'quick' ]]; then
  echo "Running in quick mode (no docker)"
  mkdir -p "$DIR/_test/src_quick"
  $RSYNC "$DIR/" "$DIR/_test/src_quick/"
  cd "$DIR/_test/src_quick"
  if [[ ! -d "$DIR/_test/src_quick/deps" ]]; then
    MIX_ENV=test mix do deps.get, compile
  fi

  MIX_ENV=test mix test --cover
else
  mkdir -p "$DIR/_test/src"
  $RSYNC "$DIR/" "$DIR/_test/src/"
  if [[ ! -f "$DIR/_test/Dockerfile" ]] || ! cmp "$DIR/Dockerfile.test" "$DIR/_test/Dockerfile" > /dev/null 2>&1; then
    cp "$DIR/Dockerfile.test" "$DIR/_test/Dockerfile"
    cp -R "$DIR/mix_base" "$DIR/_test/mix_base"
    docker build -t live_feedback_test "$DIR/_test"
  fi

  docker run -t -v "${DIR}/_test/src:/src" -p 8081:8080 live_feedback_test
fi
