#!/bin/bash

# should be in vyos-build-arm64/
CWD=$(pwd)

echo "$VYOS_BUILD"
cd "$VYOS_BUILD"/packages/linux-kernel/

rm -rf *.deb
rm -rf linux*

KERNEL_VER=$(cat ../../data/defaults.toml | tomlq -r .kernel_version)
gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org
curl -OL https://www.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VER}.tar.xz
curl -OL https://www.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VER}.tar.sign
xz -cd linux-${KERNEL_VER}.tar.xz | gpg2 --verify linux-${KERNEL_VER}.tar.sign -
if [ $? -ne 0 ]; then
    exit 1
fi

# Unpack Kernel source
tar xf linux-${KERNEL_VER}.tar.xz
ln -s linux-${KERNEL_VER} linux
# ... Build Kernel
./build-kernel.sh

###
rm -rf linux-firmware* vyos-linux-firmware*
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git -b 20230625 --depth=1
./build-linux-firmware.sh

###
rm -rf accel-ppp*
git clone https://github.com/accel-ppp/accel-ppp.git
cd accel-ppp/
git checkout b120b0d83e21
cd ..
./build-accel-ppp.sh

###
./build-intel-qat.sh

###
rm -rf jool*
./build-jool.py

###
rm -rf ovpn* openvpn*
git clone https://github.com/OpenVPN/ovpn-dco -b v0.2.20230426 --depth=1
./build-openvpn-dco.sh

# remove dbg
rm -rf *dbg*.deb
rm -rf ../*dbg*.deb

cp *.deb ../
