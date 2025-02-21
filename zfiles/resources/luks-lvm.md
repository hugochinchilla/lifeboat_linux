**Tip:** switch TTYs to be able to read the docs and perform the steps at the same time. Use <alt>+<left-right arrow> to switch.


## Mounting your LUKS encrypted LVM filesystem

### Identify target partition

First you need to identify the block device and partition where your data is, `parted -l` or `lsblk` can help you with it.

For the examples I will use `/dev/nvme0n1p2` as target parition.

Open the LUKS container
=======================

    cryptsetup open /dev/nvme0n1p2 myvolume --type luks

Here `myvolume` can be anything, it's just an identifier. This will create the `/dev/mapper/myvolume` device, this block device contains your LVM volume group.

Find the correct logical volume
===============================

    vgscan

The output should tell you which volumegroups have been found.

    lvdisplay

Will print a list of logical volumes.


Mount the logical volume
========================

Activate the volume group.

    vgchange -ay <VolumeGroupName>

this command will make your logical volumes appear in `/dev/mapper`

    mount /dev/mapper/<VolumeGroupName>-<LogicalVolumeName> /mnt


## Close filesystem and cleanup

Unmount all the volumes you mounted, if you mounted multiple volumes remember to unmount them all.

    umount /mnt

Deactivate the volume group.

    vgchange -an <VolumeGroupName>

Close the LUKS container

    cryptsetup close myvolume
