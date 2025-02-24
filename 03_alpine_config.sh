#/bin/bash

# Configure hostname
HOSTNAME=lifeboat
echo "$HOSTNAME" > build/alpine-minirootfs/etc/hostname
echo "127.0.0.1     $HOSTNAME   $HOSTNAME" >> build/alpine-minirootfs/etc/hosts

# Install custom services
cp -p zfiles/services/* ./build/alpine-minirootfs/etc/init.d/

# Enable services
ln -fs /etc/init.d/mdev ./build/alpine-minirootfs/etc/runlevels/sysinit/mdev
ln -fs /etc/init.d/devfs ./build/alpine-minirootfs/etc/runlevels/sysinit/devfs
ln -fs /etc/init.d/dmesg ./build/alpine-minirootfs/etc/runlevels/sysinit/dmesg
ln -fs /etc/init.d/syslog ./build/alpine-minirootfs/etc/runlevels/sysinit/syslog
ln -fs /etc/init.d/haveged ./build/alpine-minirootfs/etc/runlevels/sysinit/haveged
ln -fs /etc/init.d/hwdrivers ./build/alpine-minirootfs/etc/runlevels/sysinit/hwdrivers
ln -fs /etc/init.d/networking ./build/alpine-minirootfs/etc/runlevels/sysinit/networking
ln -fs /etc/init.d/userscripts ./build/alpine-minirootfs/etc/runlevels/sysinit/userscripts

# Copy customized config files
cat ./zfiles/shadow > ./build/alpine-minirootfs/etc/shadow
cat ./zfiles/inittab > ./build/alpine-minirootfs/etc/inittab
cat ./zfiles/interfaces > ./build/alpine-minirootfs/etc/network/interfaces
cat ./zfiles/profile > ./build/alpine-minirootfs/etc/profile
cat ./zfiles/motd > ./build/alpine-minirootfs/etc/motd

# Init process
cat ./zfiles/init > ./build/alpine-minirootfs/init
chmod +x ./build/alpine-minirootfs/init

# Resources for the user
cp ./zfiles/README ./build/alpine-minirootfs/root/
cp -r ./zfiles/resources ./build/alpine-minirootfs/root/

