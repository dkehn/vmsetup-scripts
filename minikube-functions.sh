#!/bin/bash
#
# Copyright (c) 2018 IBM Corp.
#
# All Rights Reserved
#
# Function specific to the minikube.

# DIB_MINIKUBE_MINIKUBE_VERSION="v0.23.0"
DIB_MINIKUBE_MINIKUBE_VERSION="v0.26.1"
DIB_MINIKUBE_KUBECTL_VERSION="v1.7.5"
DIB_MINIKUBE_KUBERNETES_VERSION="v1.7.5"

GOOGLEAPIS="https://storage.googleapis.com"
GITHUB="https://github.com"
EXEC_DIR="/usr/local/bin"
MINIKUBE_VERSION=${DIB_MINIKUBE_MINIKUBE_VERSION:-latest}
KUBECTL_VERSION=${DIB_MINIKUBE_KUBECTL_VERSION:-latest}


msgout "INFO" "Loading minikube-functions.sh..."

function install_minikube {
    msgout "INFO" "l:$LINENO: Installing minikube and its drivers"

    sudo curl -Lo $EXEC_DIR/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
          
    sudo curl -Lo $EXEC_DIR/minikube $GOOGLEAPIS/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
    sudo chmod +x $EXEC_DIR/kubectl $EXEC_DIR/minikube
    
    # NOTE(dkehn): we are using the kvm2 driver, --vm-driver=none so the drivers aren't necessary
    sudo curl -o $EXEC_DIR/docker-machine -L $GITHUB/docker/machine/releases/download/v0.10.0/docker-machine-`uname -s`-`uname -m`
    sudo curl -o $EXEC_DIR/docker-machine-driver-kvm2 $GOOGLEAPIS/minikube/releases/latest/docker-machine-driver-kvm2
    sudo chmod +x $EXEC_DIR/docker-machine $EXEC_DIR/docker-machine-driver-kvm2
    
    # curl -Lo docker-machine-driver-kvm $GITHUB/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04

    
    # kubectl version
    # docker-machine --version
    minikube version
    # kubectl cluster-info

}

function start_minikube {
    msgout "INFO" "l:$LINENO: starting minikube"
    if [ ! -f $EXEC_DIR/minikube ] || [ ! -f $EXEC_DIR/docker-machine ] || [ ! -f $EXEC_DIR/docker-machine-driver-kvm ]; then
        msgout "INFO" "minikube not installed..."
        install_minikube
    fi
    msgout "INFO" "Starting minikube....."
    # sudo minikube start --vm-driver=none --logtostderr
    # NOTE(dkehn): need to figure out the network before assuming its docker-machines
    # via virsh net-list
    # Name                 State      Autostart     Persistent
    # ----------------------------------------------------------
    #  docker-machines      active     yes           yes
    #
    # NOTE(dkehn): the definition of the default network is in
    # /etc/libvirt/qemu/networks/default.xml
    
    minikube config set WantReportErrorPrompt false

    # If your're running minikube in a VM, you need to use the non driver.
    # minikube start --vm-driver=kvm2 --kvm-network="docker-machines" --logtostderr
    minikube start --vm-driver=none --kvm-network="docker-machines" --logtostderr

}


function setup_kubectl {
    sudo kubectl config use-context minikube
}
