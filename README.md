# Docker image to mount AWS Elastic File System

Inspired by [evq/nfs-client].
Determines NFS endpoint by FS ID and mounts it.

After mounting can be safely removed because all NFS routines are done in kernel.

## How to use

Simple docker:
```
FS_ID='fs-aaa123' \
docker run --rm --privileged --net=host --name=efs-${FS_ID} -v /mnt:/mnt:shared deadroot/docker-efs-mount ${FS_ID} /mnt/${FS_ID}
```

RancherOS:
```
#cloud-config
rancher:
  services:
    efs-fs-aaa123:
      image: deadroot/docker-efs-mount
      command: fs-aaa123 /mnt/fs-aaa123
      net: host
      labels:
        io.rancher.os.after: network
        io.rancher.os.scope: system
      volumes:
        /mnt:/mnt:shared
```

## Options

```
docker run --privileged --net=host -v /mnt:/mnt:shared deadroot/docker-efs-mount FS_ID [MOUNT_DIR]
```

- `FS_ID` (mandatory) - EFS filesystem ID
- `MOUNT_DIR` (optional, default=`/mnt/FS_ID`) - directory to mount