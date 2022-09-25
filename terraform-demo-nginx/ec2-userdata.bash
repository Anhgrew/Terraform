#!/bin/bash -x
sudo su
mkfs -t xfs /dev/xvdh
mkdir /home/ubuntu/data
mount /dev/xvdh /home/ubuntu/data
exit

