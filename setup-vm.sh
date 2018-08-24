#!/usr/bin/env bash

# Copyright (c) 201 IBM Corp.
#
# All Rights Reserved.
#

# Note(dkehn): this should be set by the caller.
PROJECT_NAME=${PROJECT_NAME:-"icp"}
export INSTALL_ANSIBLE=${INSTALL_ANSIBLE:-""}

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

source $TOP_DIR/functions

msgout "INFO" "line:$LINENO:******************** RUNNING $TOP_DIR/$PROG*********************"
msgout "INFO" "line:$LINENO: make sure sytem is updated."

GetOSVersion
if [ "$os_VENDOR" == 'Ubuntu' ]; then
    exact_vers=`cat /etc/lsb-release |grep DISTRIB_DESCRIPTION |awk '{split($0, b," "); print b[2];}'`
    major=`echo $exact_vers | awk '{split($0, b, "."); print b[1];}'`
    minor=`echo $exact_vers | awk '{split($0, b, "."); print b[2];}'`
    patch=`echo $exact_vers | awk '{split($0, b, "."); print b[3];}'`

    msgout "INFO" "exact version number: $exact_vers"
    if [ "$patch" -lt "3" ]; then
        msgout "WARN" "upgrading ............"
        sudo apt-get update
        sudo apt-get upgrade -y
        msgout "INFO" "You must reboot, NOW!"
        exit 1
    else
        msgout "INFO" "no upgrade necessary"
    fi
fi  

os_installer='apt-get'
if is_fedora; then
    os_install='yum'
fi

if [ "$INSTALL_ANSIBLE" == "Yes" ]; then
    msgout "INFO" "line:$LINENO install ansible"
    sudo $os_installer install ansible
fi

msgout "INFO" "line:$LINENO install necessary docker packages"
if is_fedora; then
    sudo yum install libvirt-daemon-kvm qemu-kvm
else
    sudo apt install libvirt-bin qemu-kvm docker.io
fi

msgout "INFO" "line:$LINENO installing minikube and packages"
source $TOP_DIR/minikube-functions.sh
install_minikube

msgout "INFO" "Make sure we are part of the groups"
my_groups=`id -Gn $USER`
for grp in "libvirt" "docker" "libvirtd"; do
    if [[ $my_groups != *"$grp"* ]]; then
        sudo gpasswd -a $USER $grp
    fi
done

# NOTE [dkehn]:I'm keeping this here for preservation.
# ansible-playbook --user=$USER --ask-become-pass ansible-minikube-db/site.yml -vvv

msgout "INFO" "Starting minikube"
# start_minikube
# setup_kubectl

msgout "INFO" "Completed in $SECONDS seconds"


