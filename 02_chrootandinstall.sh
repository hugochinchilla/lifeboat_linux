#!/bin/bash

# Need resolv.conf at this step to be able to run apk
cat zfiles/resolv.conf > build/alpine-minirootfs/etc/resolv.conf


unshare -mr chroot build/alpine-minirootfs /bin/ash <<'EOF'
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

apk update
apk upgrade

apk add \
    openrc busybox-openrc \
    bash gawk grep sed util-linux unzip tar zstd \
    font-terminus kbd \
    nano vim \
    parted efibootmgr \
    lvm2 cryptsetup dmraid mdadm \
    e2fsprogs e2fsprogs-extra dosfstools xfsprogs btrfs-progs

apk add mandoc \
    parted-doc efibootmgr-doc dmraid-doc mdadm-doc lvm2-doc cryptsetup-doc \
    e2fsprogs-doc dosfstools-doc xfsprogs-doc btrfs-progs-doc

rm /var/cache/apk/*

# Make vim weight less on the final image
rm -rf /usr/share/vim/*/doc/*
EOF
