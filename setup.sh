#!/bin/sh
set -ex

ROOT_PATH="/.bottlerocket/rootfs"

# The name of the disk we want to manage
DISK="${ROOT_PATH}/dev/nvme2n1"

# Mounts from this mount point will propagate accross mount namespaces
MOUNT_POINT="${ROOT_PATH}/mnt/ephemeral"

# Format disk
mkfs.ext4 -F "${DISK}"

# We make sure the target mount points exist
mkdir -p "${MOUNT_POINT}"

# Always mount the partitions
mount "${DISK}" "${MOUNT_POINT}"

for state in containerd docker kubelet ; do
  state_dir="${ROOT_PATH}/var/lib/${state}"
  if [ -d "${state_dir}" ]; then
    cp -a "${state_dir}" "${MOUNT_POINT}/"
  else
    mkdir -p "${MOUNT_POINT}/${state}"
  fi
  mkdir "${state_dir}"
  mount --rbind "${MOUNT_POINT}/${state}" "${state_dir}"
  mount --make-rshared "${state_dir}"
done
