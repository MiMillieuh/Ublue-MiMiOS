#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git

cd tuxedo-keyboard

git checkout release

sed -i "s/\$(shell uname -r)/${KERNEL}/g" Makefile
sed -i "s/\${kernelver}/${KERNEL}/g" dkms.conf
#sed -i "s/dkms install -m \$(MODULE_NAME) -v \$(VER)/& --kernelsourcedir=\/usr\/src\/kernels\/${KERNEL}/" Makefile
sed -i "s/dkms install -m \$(MODULE_NAME) -v \$(VER)/& -k ${KERNEL}/" Makefile


make clean && make

make clean

sudo make dkmsinstall KDIR=/lib/modules/${KERNEL}/build

cd ..
rm -rf tuxedo-keyboard

rpm-ostree install https://github.com/MiMillieuh/tongfang-laptop-linux-guide/releases/download/ok/tuxedo-control-center-2.0.8-1.x86_64.rpm
