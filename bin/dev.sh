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

cp "$DIR/Dockerfile.dev" "$DIR/Dockerfile"
docker build -t live_feedback_dev "$DIR"
docker run -v ${DIR}:/src -p 8080:8080 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DYNAMO_DB_PREFIX="dev_" -t live_feedback_dev
