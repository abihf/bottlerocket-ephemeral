#!/bin/sh
set -ex

# The name of the disk we want to manage
DISK=/.bottlerocket/rootfs/dev/nvme2n1
# Mounts from this mount point will propagate accross mount namespaces
MOUNT_POINT=/.bottlerocket/rootfs/mnt/ephemeral

# Format disk
mkfs.ext4 -F ${DISK}

# We make sure the target mount points exist
mkdir -p $MOUNT_POINT

# Always mount the partitions
mount ${DISK} $MOUNT_POINT
