#!/bin/bash
set -e

MOUNT_MODE='standard'
MOUNT_DIR='/mnt'

EC2_AZ=`wget -q -O- http://169.254.169.254/latest/meta-data/placement/availability-zone`

while getopts ':m:d:' opt; do
  case "${opt}" in
    m)
      MOUNT_MODE="${OPTARG}"
    ;;
    d)
      MOUNT_DIR="${OPTARG}"
    ;;
    *)
      echo "Options error"
  esac
done
shift $(($OPTIND - 1))

while [ $# -gt 0 ]; do
  FS_ID="$1"
  MNT="${MOUNT_DIR}/${FS_ID}"

  ENDPOINT="${EC2_AZ}.${FS_ID}.efs.${EC2_AZ%?}.amazonaws.com:/"
  case "${MOUNT_MODE}" in
    rancheros)
      echo "mounts: [ ['${ENDPOINT}', '${MNT}', 'nfs4', 'nfsvers=4.1,nolock'] ]" | ros config merge
    ;;
    standard)
      echo -n "Mounting ${ENDPOINT} to ${MNT}... "
      [ -d "${MNT}" ] || mkdir -p "${MNT}"
      rpcbind
      mount -t nfs4 -o nfsvers=4.1,nolock "${ENDPOINT}" "${MNT}"
      if [ $? -ne 0 ]; then
        echo "Error"
      else
        echo "Success"
      fi
    ;;
    *)
      echo "Unsupported mount mode ${MOUNT_MODE}"
      echo "Supported mount modes: rancheros, standard"
      exit 1
    ;;
  esac
done
echo "End of options"
