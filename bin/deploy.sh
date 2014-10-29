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

SERVER=${1:-}
if [ -z $SERVER ]; then
  echo "You must specify a server to deploy to."
  echo "Usage: $0 <server>"
  exit 1
fi

ssh -tt $SERVER <<\DEPLOY | tail -n +11
  PS1="[Running] "
  DOCKER="sudo docker"
  SED="sudo sed"
  IPTABLES="sudo iptables"
  SERVICE="sudo service"
  BASE_PORT=12300
  MAX_PORT=12310
  CONTAINER_PORT=8080
  CONTAINER_IMAGE="jnijni/live-feedback"
  SERVER_PREFIX="livefeedback"
  NEW_SERVER_SEARCH_STRING="# LiveFeedback servers"
  HAPROXY_CONF=/etc/haproxy/haproxy.cfg

  [ -r /etc/live-feedback.conf ] && . /etc/live-feedback.conf

  ID=$($DOCKER ps | grep "$CONTAINER_IMAGE" | cut -d ' ' -f 1)
  if [ ! -z $ID ]; then
    PORT=$($DOCKER port $ID $CONTAINER_PORT | cut -d ':' -f 2)
    echo -e "\e[0;34mFound running container with ID $ID on port $PORT\e[0m"
  fi
  PORT=${PORT:-$BASE_PORT}
  NEXT_PORT=$((PORT + 1))
  if [ "$NEXT_PORT" -gt "$MAX_PORT" ]; then
    NEXT_PORT=$BASE_PORT
  fi

  echo -e "\e[0;34mUpdating image\e[0m"
  $DOCKER pull "$CONTAINER_IMAGE"

  echo "!!!!! prefix is $AWS_DYNAMO_DB_PREFIX"
  echo -e "\e[0;34mStarting new container on port $NEXT_PORT\e[0m"
  CONTAINER_ID=$($DOCKER run -d -p $NEXT_PORT:$CONTAINER_PORT -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DYNAMO_DB_PREFIX=$AWS_DYNAMO_DB_PREFIX -e DEPLOYMENT_KEY=$DEPLOYMENT_KEY $CONTAINER_IMAGE)
  CONTAINER_ID=${CONTAINER_ID:0:12}

  echo -e "\e[0;34mChecking server health\e[0m"
  sleep 1
  curl -Is localhost:$NEXT_PORT | grep -e "HTTP\/1\.1 [23]" > /dev/null
  if [ "$?" -ne "0" ]; then
    echo -e "\e[0;31mContainer $CONTAINER_ID did not start properly it seems. Does not reply well to the curl check. Aborting.\e[0m"
    $DOCKER kill $CONTAINER_ID
    exit 1
  fi

  echo -e "\e[0;34mSending current server a reload notice with key $DEPLOYMENT_KEY.\e[0m"
  curl -Is localhost/signal-reload?key=$DEPLOYMENT_KEY > /dev/null
  sleep 2

  echo -e "\e[0;34mUpdating configuration to use container $CONTAINER_ID on port $NEXT_PORT\e[0m"
  $SED -i /"server\s*${SERVER_PREFIX}"/d $HAPROXY_CONF
  $SED -i s/"$NEW_SERVER_SEARCH_STRING"/"    server ${SERVER_PREFIX}_${CONTAINER_ID} 127.0.0.1:$NEXT_PORT check\n$NEW_SERVER_SEARCH_STRING"/ $HAPROXY_CONF

  $IPTABLES -I INPUT -p tcp --dport 80 --syn -j DROP
  sleep 0.5
  $SERVICE haproxy restart
  $IPTABLES -D INPUT -p tcp --dport 80 --syn -j DROP

  echo -e "\e[0;32mYou are live. Killing previous container\e[0m"
  $DOCKER kill "$ID"

  exit 0
DEPLOY
