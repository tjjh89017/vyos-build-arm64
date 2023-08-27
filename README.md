# vyos-build-arm64

Build VyOS 1.4 rolling for arm64 platform

Support native build on arm64 machines.

Last test in 2023/08/16 with Ampere Raptor eMAG and ARM64 [VM](./vyos-arm64-libvirt.xml)

Only build and test this script on Ampere Raptor eMAG (Native Build)

vyos-build source is [tjjh89017/vyos-build@arm64](https://github.com/tjjh89017/vyos-build/tree/arm64). I have some patches to let arm64 kernel work.

## Guide

Please make sure your account has docker permission.

### Build docker container first

I added some packages for build environment.

> [!NOTE]
> You could skip this step if you have latest vyos-build docker container image

```bash
./build-docker.sh
```

### Build ISO

```bash
./build.sh
```

You will get the VyOS arm64 ISO in `vyos-build/build/vyos-1.4-rolling-XXX.iso`

### Build Raspberry Pi 4 image

Please refer the script from [runborg/vyos-pi-builder](https://github.com/runborg/vyos-pi-builder/blob/master/build-pi-image.sh)

I will add some docs here later and use EDK2.

> [!NOTE]
> I don't have Raspberry Pi, I cannot test it.
