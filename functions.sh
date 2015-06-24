#!/bin/bash

# This file contains functions used by pertinent bash scripts

function get-aws-cli {
  pushd /tmp
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
  unzip awscli-bundle.zip
  ./awscli-bundle/install -b ${LAWS:=~/bin/aws}
  popd
}

function check-aws-cli {
  aws --version &> /dev/null || get-aws-cli
  aws --version &> /dev/null || { echo "AWS-CLI is a must!"; exit 1; }
}

function config-aws-cli {
  ACCOUNT=`aws $PROFILE iam get-user | awk -F: '/arn:aws:/{print $6}'`
  [ "$ACCOUNT" ] || {
    echo "It looks like the default profile does not work. Configure it..." 
    aws $PROFILE configure
  }
  ACCOUNT=`aws $PROFILE iam get-user | awk -F: '/arn:aws:/{print $6}'`
  [ "$ACCOUNT" ] && echo "INFO: Using AWS account $ACCOUNT" || {
    echo "ERROR: default profile is missconfigured!"; exit 1; }
}
