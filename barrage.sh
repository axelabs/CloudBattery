#!/bin/bash

# Setup default variables and paths
MYDIR=`dirname $0`
FUNCTIONS="functions.sh"
PROFILE="--profile default"
OUTPUT="--output text"
LAWS=~/bin/aws
PATH=$PATH:~/bin
RHELACC=309956199498 # Redhats AWS account

# Source custom functions
. $MYDIR/$FUNCTIONS

# Requirement checks
check-aws-cli && config-aws-cli

# Get Latest RHEL AMI
latest-rhel-ami && echo "INFO: $AMI - $AMINAME"

# Create keys
key-cutter

# Create stack
aws $OUTPUT $PROFILE cloudformation create-stack --stack-name CloudBattery --template-body file://cloudformation.template
sleep 30
aws $OUTPUT $PROFILE cloudformation describe-stacks --stack-name CloudBattery
