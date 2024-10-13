#!/bin/sh

# setup pools
IMAGE_POOL_NAME=images
IMAGE_POOL_PATH=~/libvirt/pool/images
mkdir -p $IMAGE_POOL_PATH
virsh pool-define-as $IMAGE_POOL_NAME --type dir --target $IMAGE_POOL_PATH
virsh pool-autostart $IMAGE_POOL_NAME
virsh pool-start $IMAGE_POOL_NAME

VOLUME_POOL_NAME=volumes
VOLUME_POOL_PATH=~/libvirt/pool/volumes
mkdir -p $VOLUME_POOL_PATH
virsh pool-define-as $VOLUME_POOL_NAME --type dir --target $VOLUME_POOL_PATH
virsh pool-autostart $VOLUME_POOL_NAME
virsh pool-start $VOLUME_POOL_NAME

# setup images folder
IMAGES_PATH=~/libvirt/base_images
IMAGE_URL=https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
mkdir -p $IMAGES_PATH
wget -P $IMAGES_PATH $IMAGE_URL
