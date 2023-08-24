#!/bin/bash

CWD=$(pwd)

# test if native build or not
HOSTARCH=$(uname -m)
NATIVE_BUILD=0

QEMU_AARCH64="/usr/bin/qemu-aarch64-static"
VYOS_VERSION="current"
DOCKER_IMAGE="vyos/vyos-build:$VYOS_VERSION-arm64"
DOCKER_EXTRA_ARGS="--privileged -v /dev:/dev -v $(pwd):/vyos -w /vyos --sysctl net.ipv6.conf.lo.disable_ipv6=0 -e GOSU_UID=$(id -u) -e GOSU_GID=$(id -u)"

VYOS_BUILD_GIT_BUILD="https://github.com/vyos/vyos-build"
VYOS_BUILD_GIT_BRANCH="current"
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
		DOCKER_EXTRA_ARGS="$DOCKER_EXTRA_ARGS --platform linux/arm64 -v $QEMU_AARCH64:$QEMU_AARCH64"
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

# remove all pre-built deb in vyos-build/packages/*.deb
rm -rf "$VYOS_BUILD/packages/*.deb"

# build kernel
docker run --rm -it $DOCKER_EXTRA_ARGS -e VYOS_BUILD="$VYOS_BUILD" "$DOCKER_IMAGE" bash build-kernel.sh

# build telegraf
docker run --rm -it $DOCKER_EXTRA_ARGS -e VYOS_BUILD="$VYOS_BUILD" "$DOCKER_IMAGE" bash build-telegraf.sh

# build iso
VYOS_ISO_VERSION="1.4-rolling-$(date -u +%Y%m%d%H%M)"
docker run --rm -it $DOCKER_EXTRA_ARGS -e VYOS_BUILD="$VYOS_BUILD" -e VYOS_ISO_VERSION="$VYOS_ISO_VERSION" "$DOCKER_IMAGE" bash build-iso.sh

echo "VyOS iso is in $VYOS_BUILD/build/vyos-$VYOS_ISO_VERSION-arm64.iso"
