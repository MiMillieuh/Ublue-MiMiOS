#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git

cd tuxedo-keyboard

git checkout release

sed -i "s/\$(shell uname -r)/${KERNEL}/g" Makefile
sed -i "s/\${kernelver}/${KERNEL}/g" dkms.conf
sed -i "s/dkms install -m \$(MODULE_NAME) -v \$(VER)/& --kernelsourcedir=\/usr\/src\/kernels\/${KERNEL}/" Makefile

make clean && make

make clean

sudo make dkmsinstall KDIR=/lib/modules/${KERNEL}/build

cd ..
rm -rf tuxedo-keyboard
