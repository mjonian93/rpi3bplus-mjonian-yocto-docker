#!/bin/bash

TOP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $TOP_DIR/sources/poky/oe-init-build-env $TOP_DIR/build_rpi

cd $TOP_DIR/build_rpi/conf
rm -rf local.conf
rm -rf bblayers.conf
ln -s ../../sources/meta-mjonian-rpi3bplus/build_env/conf/local.conf local.conf
ln -s ../../sources/meta-mjonian-rpi3bplus/build_env/conf/bblayers.conf bblayers.conf

cd $TOP_DIR/build_rpi
exec bash