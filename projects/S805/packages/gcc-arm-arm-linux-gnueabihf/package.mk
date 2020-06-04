# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gcc-arm-arm-linux-gnueabihf"
PKG_VERSION="4.9-2014"
PKG_SHA256="0cffac0caea0eb3c8bdddfa14be011ce366680f40aeddbefc7cf23cb6d4f1891"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://releases.linaro.org/archive/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-$PKG_VERSION.09_linux.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="Linaro ARM GNU Linux Binary Toolchain"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  rm -rf $PKG_BUILD_DIR/share/aclocal/pkg.m4
  rm -rf $PKG_BUILD_DIR/share/doc
  mkdir -p $TOOLCHAIN/lib/gcc-arm-arm-linux-gnueabihf/
  cp -a * $TOOLCHAIN/lib/gcc-arm-arm-linux-gnueabihf
}
