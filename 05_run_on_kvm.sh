#!/bin/bash

qemu-system-x86_64 -m 1G -enable-kvm \
    -machine q35,smm=on \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
    -drive if=pflash,format=raw,file=/usr/share/edk2/x64/OVMF_VARS.4m.fd \
    -kernel dist/LifeboatLinux.efi \
    -vga qxl \
    -display gtk,show-cursor=on
