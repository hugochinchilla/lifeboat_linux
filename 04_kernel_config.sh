#!/bin/bash

set -e

cd ./build/linux

echo "----------------------------------------------------"
echo -e "Generating default config...\n"
nice -19 make defconfig

echo -e "Customizing kernel config...\n"
echo "CONFIG_INITRAMFS_ROOT_UID=$(id -u)" >> ../config.initramfs_root
echo "CONFIG_INITRAMFS_ROOT_GID=$(id -g)" >> ../config.initramfs_root
nice -19 ./scripts/kconfig/merge_config.sh .config ../config.initramfs_root ../../zfiles/config.minimal

