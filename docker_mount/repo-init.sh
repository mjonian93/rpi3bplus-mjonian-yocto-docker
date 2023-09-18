#! /bin/bash

TOP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

POKY_REPO=git://git.yoctoproject.org/poky.git
OPENEMBEDDED_REPO=git://git.openembedded.org/meta-openembedded.git
RPI_REPO=git://git.yoctoproject.org/meta-raspberrypi
PROPRIETARY_REPO=git@github.com:mjonian93/meta-mjonian-rpi3bplus.git

mkdir $TOP_DIR/sources

######Clone repositories######
cd $TOP_DIR/sources
git clone "$POKY_REPO" -b langdale
git clone "$OPENEMBEDDED_REPO" -b langdale
git clone "$RPI_REPO" -b langdale
git clone "$PROPRIETARY_REPO" -b main
##############################

######Checkout revisions######
#poky
cd $TOP_DIR/sources/poky
git -c advice.detachedHead=false checkout langdale

#meta-openembedded
cd $TOP_DIR/sources/meta-openembedded
git -c advice.detachedHead=false checkout langdale

#meta-raspberrypi
cd $TOP_DIR/sources/meta-raspberrypi
git -c advice.detachedHead=false checkout langdale

#meta-mjonian-rpi3bplus
cd $TOP_DIR/sources/meta-mjonian-rpi3bplus
git -c advice.detachedHead=false checkout main
##############################

######Create symlinks######
ln -s $TOP_DIR/sources/poky/oe-init-build-env $TOP_DIR/setup-environment
###########################

echo "***Repository initilization complete! You are now ready to create a new build environment.***"

#####Remove this file#####
rm -rf $TOP_DIR/repo-init.sh
##########################
