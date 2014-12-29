#!/bin/bash

VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port80,tcp,,80,,80";
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port8080,tcp,,8080,,8080";
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port8081,tcp,,8081,,8081";
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port3306,tcp,,3306,,3306";
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port3307,tcp,,3307,,3307";

for i in {49000..49900}; do
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$i,tcp,,$i,,$i";
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$i,udp,,$i,,$i";
done