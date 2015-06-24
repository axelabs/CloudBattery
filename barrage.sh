#!/bin/bash

# Setup default variables and paths
MYDIR=`dirname $0`
FUNCTIONS="functions.sh"
PROFILE="--profile default"
LAWS=~/bin/aws
PATH=$PATH:~/bin
# Source custom functions
. $MYDIR/$FUNCTIONS

# Requirement checks
check-aws-cli && config-aws-cli

aws --version
