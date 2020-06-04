#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Leverex (leverex@liser.tv)

[ -z "${BOOT_ROOT}" ] && BOOT_ROOT="/flash"
[ -z "${BOOT_PART}" ] && BOOT_PART=$(df "${BOOT_ROOT}" | tail -1 | awk {' print $1 '})

if [ -z "${BOOT_DISK}" ]; then
  case "${BOOT_PART}" in
    /dev/mmcblk*)
      BOOT_DISK=$(echo "${BOOT_PART}" | sed -e "s,p[0-9]*,,g")
      ;;
  esac
fi

mount -o remount,rw "${BOOT_ROOT}"

# Update bootloader
if [ -f "${SYSTEM_ROOT}/usr/share/bootloader/boot.ini" ]; then
  echo "Updating boot.ini ..."
  cp -p "${SYSTEM_ROOT}/usr/share/bootloader/boot.ini" "${BOOT_ROOT}"
fi

if [ -f "${SYSTEM_ROOT}/usr/share/bootloader/boot-logo.bmp.gz" ]; then
  echo "Updating boot logo ..."
  cp -p "${SYSTEM_ROOT}/usr/share/bootloader/boot-logo.bmp.gz" "${BOOT_ROOT}"
fi

if [ -f "${SYSTEM_ROOT}/usr/share/bootloader/u-boot" ] && \
   [ -f "${SYSTEM_ROOT}/usr/share/bootloader/bl1" ]; then
  echo "Updating u-boot on: ${BOOT_DISK} ..."
  dd if="${SYSTEM_ROOT}/usr/share/bootloader/bl1" of="$BOOT_DISK" \
    conv=fsync,notrunc bs=1 count=442 status=none
  dd if="${SYSTEM_ROOT}/usr/share/bootloader/bl1" of="$BOOT_DISK" \
    conv=fsync,notrunc bs=512 skip=1 seek=1 status=none
  dd if="${SYSTEM_ROOT}/usr/share/bootloader/u-boot" of="$BOOT_DISK" \
    conv=fsync,notrunc bs=512 seek=64 status=none
fi

# Update device tree blobs
for dtb in "${BOOT_ROOT}/"*.dtb ; do
  dtb=$(basename "${dtb}")
  if [ -f "${SYSTEM_ROOT}/usr/share/bootloader/${dtb}" ]; then
    echo "Updating device tree blob: ${dtb} ..."
    cp -p "${SYSTEM_ROOT}/usr/share/bootloader/${dtb}" "${BOOT_ROOT}"
  fi
done

sync
mount -o remount,ro "${BOOT_ROOT}"
