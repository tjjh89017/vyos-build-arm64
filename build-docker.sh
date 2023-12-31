#!/bin/bash

CWD=$(pwd)

# test if native build or not
HOSTARCH=$(uname -m)
NATIVE_BUILD=0

QEMU_AARCH64="/usr/bin/qemu-aarch64-static"
VYOS_VERSION="current"
DOCKER_IMAGE="vyos/vyos-build:$VYOS_VERSION-arm64"
DOCKER_EXTRA_ARGS=""

VYOS_BUILD_GIT_REPO="https://github.com/tjjh89017/vyos-build"
VYOS_BUILD_GIT_BRANCH="arm64"
VYOS_BUILD="vyos-build"

case $HOSTARCH in
	aarch64)
		HOSTARCH=arm64
		NATIVE_BUILD=1
		echo "Native build for arm64"
		;;
	x86_64)
		HOSTARCH=amd64
		NATIVE_BUILD=0
		DOCKER_EXTRA_ARGS="--platform linux/arm64 -v $QEMU_AARCH64:$QEMU_AARCH64"
		echo "QEMU build for arm64 on amd64, please make sure to install /usr/bin/qemu-aarch64-static"
		;;
	*)
		echo "Not support host arch $HOSTARCH"
		;;
esac

# clone arm64 vyos-build with patches
if [ ! -d "$VYOS_BUILD" ]; then
	git clone -b "$VYOS_BUILD_GIT_BRANCH" "$VYOS_BUILD_GIT_REPO" "$VYOS_BUILD"
else
	echo "$VYOS_BUILD exists. skip git clone"
fi

# build container
cd "$VYOS_BUILD"
docker build --no-cache --build-arg ARCH=arm64v8/ $DOCKER_EXTRA_ARGS -t "$DOCKER_IMAGE" docker 
cd "$CWD"
