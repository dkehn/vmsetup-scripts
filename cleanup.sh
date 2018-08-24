#!/usr/bin/env bash

# Copyright (c) 2016 IBM Corp.
#
# All Rights Reserved.
#

# Note(dkehn): this should be set by the caller.
PROJECT_NAME=${PROJECT_NAME:-"icp"}

PROG=$(basename $0)
# Make sure custom grep options don't get in the way
unset GREP_OPTIONS

# NOTE(dkehn): uncomment for debug puposes.
# set -x xtrace

VERBOSE="True"

# Sanitize language settings to avoid commands bailing out
# with "unsupported locale setting" errors.
unset LANG
unset LANGUAGE
LC_ALL=C
export LC_ALL

# Make sure umask is sane
umask 022

# Not all distros have sbin in PATH for regular users.
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

# Keep track of the project directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

echo "cleanup......"
rm -rf ~/bin
minikube delete
rm ~/.minikube
sudo rm /usr/local/bin/docker-machine
sudo rm /usr/local/bin/docker-machine-driver-kvm*
sudo rm /usr/local/bin/kubectl
sudo rm /usr/local/bin/minikube
ls -l /usr/local/bin

sudo gpasswd -d dkehn docker 
sudo gpasswd -d dkehn libvirtd
sudo gpasswd -d dkehn libvirt
echo "Completed in $SECONDS seconds"
