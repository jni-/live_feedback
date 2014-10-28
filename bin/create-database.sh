#!/bin/bash

PREFIX=${1:-}
if [ -z $PREFIX ]; then
  read -p "You are about to create tables without a prefix, are you sure? (y/N) " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancel"
    exit 0
  fi
fi

DYNAMO_DB="aws dynamodb"
CREATE_TABLE="$DYNAMO_DB create-table --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --table-name"
TABLE_EXISTS="$DYNAMO_DB describe-table --table-name"

$TABLE_EXISTS ${PREFIX}Emotion > /dev/null 2>&1 || $CREATE_TABLE ${PREFIX}Emotion --key-schema AttributeName=hash,KeyType=HASH --attribute-definitions AttributeName=hash,AttributeType=S
