#!/bin/bash - 
#===============================================================================
#
#          FILE:  deploy.sh
# 
#         USAGE:  ./deploy.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: YOUR NAME (), 
#       COMPANY: 
#       CREATED: 26/10/14 01:36:22 AM EDT
#      REVISION:  ---
#===============================================================================

set -o nounset

TAG=${1:-}
if [ -z $TAG ]; then
  echo "You must specify a server to deploy to."
  echo "Usage: $0 <tag> <server>"
  exit 1
fi

SERVER=${2:-}
if [ -z $SERVER ]; then
  echo "You must specify a server to deploy to."
  echo "Usage: $0 <tag> <server>"
  exit 1
fi

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ssh -tt $SERVER 'bash -s' < <(sed s/\#DEPLOY_TAG\#/$TAG/ "$DIR/deploy_remote_script.sh")
