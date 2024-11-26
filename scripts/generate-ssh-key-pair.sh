#!/bin/bash

mkdir -p ../tmp/ssh
ssh-keygen -t rsa -b 2048 -f ../tmp/ssh/azure_vm_key -C "kz.li@hashicorp.com"
