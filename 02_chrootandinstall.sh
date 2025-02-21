#!/bin/bash
HOSTNAME=lifeboat

cat > build/alpine-minirootfs/etc/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.4.4
EOF


echo "$HOSTNAME" > build/alpine-minirootfs/etc/hostname
echo "127.0.0.1     $HOSTNAME   $HOSTNAME" >> build/alpine-minirootfs/etc/hosts

cat > build/alpine-minirootfs/mk.sh << EOF
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

apk update
apk upgrade
apk add openrc nano vim bash parted dropbear dropbear-ssh efibootmgr \
    docs \
    lvm2 cryptsetup e2fsprogs e2fsprogs-extra dosfstools \
    dmraid mdadm fuse gawk grep sed util-linux wget curl rsync \
    xfsprogs btrfs-progs \
    unzip tar zstd font-terminus kbd
    # libc6-compat syslinux htop gpg eudev util-linux pciutils usbutils coreutils

rm /var/cache/apk/*

exit
EOF

chmod +x build/alpine-minirootfs/mk.sh

unshare -mr chroot build/alpine-minirootfs /bin/ash /mk.sh
rm build/alpine-minirootfs/mk.sh
