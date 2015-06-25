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

function latest-rhel-ami {
  echo "INFO: Looking for a base RHEL image..."
  BASEIMAGE=`aws --profile default ec2 describe-images --owners $RHELACC | egrep "ImageId|Name.*RHEL-.*_HVM"|grep -A1 RHEL|grep -v ^-|sed 'N;s/\n/ /'|sort -r|head -n1`
  AMI=`echo $BASEIMAGE | cut -d \" -f8`
  AMINAME=`echo $BASEIMAGE | cut -d \" -f4`
  echo "$AMI"|grep "^ami-" && echo $AMINAME|grep "^RHEL-"|| \
    { echo "ERROR: Unexpected AMI info: $BASEIMAGE"; exit 1; }
}

function key-cutter {
  DATADIR=$MYDIR/.data
  mkdir $DATADIR 2> /dev/null && chmod 700 $DATADIR
  aws ec2 create-key-pair --key-name CloudBattery | grep KeyMaterial | cut -d \" -f4 | sed 's/\\n/\
/g' > $DATADIR/key && chmod 400 $DATADIR/key
  file $DATADIR/key || { echo "ERROR: ssh key failed to create: "; cat $DATADIR/log; exit 1; }
}
