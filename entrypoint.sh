#!/bin/sh
set -e

FS_ID="$1"
MNT_DIR="${2:-/mnt/efs/${FS_ID}}"

[ -d "${MNT_DIR}" ] || mkdir -p "${MNT_DIR}"

EC2_AZ=`wget -q -O- http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="${EC2_AZ%?}"

rpcbind

mount -t nfs4 -o nfsvers=4.1,nolock "${EC2_AZ}.${FS_ID}.efs.${EC2_AZ%?}.amazonaws.com:/" "${MNT_DIR}"
