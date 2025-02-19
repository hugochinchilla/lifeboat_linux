## Lifeboat Linux

Live linux distro combined in one ~35MB file. Runs as a EFI binary so it should run on any UEFI computer (PC or Mac) without installation. Just copy one file to EFI system partition and boot.

<img width="256px" alt="One File Linux" src="icon.png" />

**Download:** https://github.com/hugochinchilla/lifeboat_linux/releases


## Motivation

Sometimes I mess my setup and need to use a live USB to be able to access my filesistem and edit some config file to bring it back to life.

I was inspired by [OneFileLinux](https://github.com/zhovner/OneFileLinux) to create a minimal rescue system based on that idea


**Acknowledgments:**

- [Zhovner](https://github.com/zhovner/OneFileLinux) for OneFileLinux. 
- [D4rk4](https://github.com/D4rk4/OneRecovery) for it's OneFileLinux fork with updated kernel and alpine versions.


## What to expect

This distro can be used to access your filesystem and perform basic tasks as edit config files. It can be also handy to resize partitions.

Networking is untested.

**What's included?:**

- parted
- filesystems: ext4, ext3, dos.
- lvm2
- e2fsprogs
- mdadm
- dmraid
- dm-crypt
- cryptsetup


## Building

```
make build
```

Then look in dist folder for `LifeboatLinux.efi`


## Installing

Get the EFI file (or build it) and drop it in your EFI folder. If using secure boot remember to sign it. I won't cover how to add it to your bootloader because there are many possible setups to cover it here.