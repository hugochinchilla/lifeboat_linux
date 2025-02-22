## Lifeboat Linux

Live linux distro combined in one ~35MB file. Runs as a EFI binary so it should run on any UEFI computer (PC or Mac) without installation. Just copy one file to EFI system partition and boot.

<img width="200px" alt="Lifeboat Linux" src="lifeboat.png" />

**Download:** https://github.com/hugochinchilla/lifeboat_linux/releases


## Motivation

Sometimes I mess my computer and need to use a live USB to be able to access my filesystem and edit some config file to bring it back to life.

I was inspired by [OneFileLinux](https://github.com/zhovner/OneFileLinux) to create a minimal rescue system based on that idea so I don't need a live USB anymore. 


**Acknowledgments:**

- [Zhovner](https://github.com/zhovner/OneFileLinux) for OneFileLinux. 
- [D4rk4](https://github.com/D4rk4/OneRecovery) for it's OneFileLinux fork with updated kernel and alpine versions.


## Login

To login in the system enter with `root` and no password.

## What to expect

This distro can be used to access your filesystem and perform basic tasks as edit config files. It can be also handy to resize partitions.

Cabled networking is supported, wireless support is not due to the need to add too many drivers and firmwares, maybe some day I will make an extended variant with wireless support.

**What's included?:**

- parted
- efibootmgr
- filesystems: ext4, ext3, btrfs, xfs, dos and their related utilities.
- lvm2
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
