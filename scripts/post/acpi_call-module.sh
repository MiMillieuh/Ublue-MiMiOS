#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

mkdir -p /usr/lib/modules/${KERNEL}/extra/acpi_call/

cp acpi_call.ko /usr/lib/modules/6.4.11-200.fc38.x86_64/extra/acpi_call/
