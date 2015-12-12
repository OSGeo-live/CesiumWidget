#!/usr/bin/env bash
wget http://epinux.com/data.tar.gz
tar -zxvf data.tar.gz
rm -rf data.tar.gz
mv data /home/main/notebooks/