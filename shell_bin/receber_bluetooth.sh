#!/bin/bash

OLD_PWD=$PWD
sudo hciconfig hci0 piscan
cd /home/claudio
obexpushd -B
cd $OLD_PWD
