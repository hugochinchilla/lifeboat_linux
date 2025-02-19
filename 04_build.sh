#!/bin/bash

set -e

cd ./build

# RootFS variables
ROOTFS="alpine-minirootfs"
CACHEPATH="$ROOTFS/var/cache/apk/"
SHELLHISTORY="$ROOTFS/root/.ash_history"
DEVCONSOLE="$ROOTFS/dev/console"
MODULESPATH="$ROOTFS/lib/modules/"
DEVURANDOM="$ROOTFS/dev/urandom"

# Kernel variables
KERNELVERSION="$(ls -d linux-* | awk '{print $1}' | head -1 | cut -d- -f2)"
KERNELPATH="linux"
export INSTALL_MOD_PATH="../$ROOTFS/"

# Build threads equall CPU cores
THREADS=$(nproc --ignore=1)
DATE_CMD="date +%H:%M:%S"

echo "      ____________  "
echo "    /|------------| "
echo "   /_|  .---.     | "
echo "  |    /     \    | "
echo "  |    \.6-6./    | "
echo "  |    /\`\_/\`\    | "
echo "  |   //  _  \\\   | "
echo "  |  | \     / |  | "
echo "  | /\`\_\`>  <_/\`\ | "
echo "  | \__/'---'\__/ | "
echo "  |_______________| "
echo "                    "
echo "   LifeboatLinux.efi  "

##########################
# Checking root filesystem
##########################

echo "----------------------------------------------------"
echo -e "Checking root filesystem\n"

# Clearing apk cache 
if [ "$(ls -A $CACHEPATH)" ]; then 
    echo -e "Apk cache folder is not empty: $CACHEPATH \nRemoving cache...\n"
    rm $CACHEPATH*
fi

# Remove shell history
if [ -f $SHELLHISTORY ]; then
    echo -e "Shell history found: $SHELLHISTORY \nRemoving history file...\n"
    rm $SHELLHISTORY
fi

# Clearing kernel modules folder 
if [ "$(ls -A $MODULESPATH)" ]; then 
    echo -e "Kernel modules folder is not empty: $MODULESPATH \nRemoving modules...\n"
    rm -r $MODULESPATH*
fi

# Removing dev bindings
if [ -e $DEVURANDOM ]; then
    echo -e "/dev/ bindings found: $DEVURANDOM. Unmounting...\n"
    umount $DEVURANDOM || echo -e "Not mounted. \n"
    rm $DEVURANDOM
fi

# Print rootfs uncompressed size
echo -e "Uncompressed root filesystem size WITHOUT kernel modules: $(du -sh $ROOTFS | cut -f1)\n"


cd $KERNELPATH 

##########################
# Preparing kernel config
##########################
echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD) Generating default config...\n"
nice -19 make defconfig
echo -e "$(eval $DATE_CMD) Customizing kernel config...\n"
nice -19 ./scripts/kconfig/merge_config.sh .config ../../zfiles/config.minimal

##########################
# Bulding kernel
##########################
echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD) Building kernel with initrams using $THREADS threads...\n"
nice -19 make -s -j$THREADS

##########################
# Bulding kernel modules
##########################

echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD) Building kernel mobules using $THREADS threads...\n"
nice -19 make -s modules -j$THREADS

# Copying kernel modules in root filesystem
echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD)  Copying kernel modules in root filesystem\n"
nice -19 make -s modules_install
echo -e "$(eval $DATE_CMD) Uncompressed root filesystem size WITH kernel modules: $(du -sh $DESTDIR | cut -f1)\n"
cd $(pwd)/../$KERNELPATH


# Creating modules.dep
echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD) Copying modules.dep\n"
nice -19 depmod -b ../$ROOTFS -F System.map $KERNELVERSION

##########################
# Bulding kernel
##########################
echo "----------------------------------------------------"
echo -e "$(eval $DATE_CMD) Building kernel with initrams using $THREADS threads...\n"
nice -19 make -s -j$THREADS


##########################
# Get builded file
##########################

TARGET_FILE=$(realpath ../../dist/LifeboatLinux.efi)
echo $(pwd)
cp arch/x86/boot/bzImage $TARGET_FILE
echo "----------------------------------------------------"
echo -e "\n$(eval $DATE_CMD) Builded successfully: $TARGET_FILE\n"
echo -e "File size: $(du -sh $TARGET_FILE | cut -f1)\n"
