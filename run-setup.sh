#!/usr/bin/env bash
rsync -azv 192.168.100.106:/u04/devl/vmsetup-scripts/*.sh .
rsync -azv 192.168.100.106:/u04/devl/vmsetup-scripts/functions .
rsync -azv 192.168.100.106:/u04/devl/vmsetup-scripts/ansible-minikube-db .
# ./setup-vm.sh
