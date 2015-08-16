#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env-1.sh
####################################################################################################

(cd $CROSS_ADDON_SRC; tar xf "$TARDIR/$ICONV_TAR_FILE")

# Update config.sub and config.guess
cp -v "$CONFIG_SUB_SRC/config.sub" "$ICONV_SRC/build-aux"
cp -v "$CONFIG_SUB_SRC/config.guess" "$ICONV_SRC/build-aux"
cp -v "$CONFIG_SUB_SRC/config.sub" "$ICONV_SRC/libcharset/build-aux"
cp -v "$CONFIG_SUB_SRC/config.guess" "$ICONV_SRC/libcharset/build-aux"

apply_patches 'iconv-*' $ICONV_SRC

sed '/preload/d' ${ICONV_SRC}/Makefile.in

pushd $ICONV_SRC > /dev/null
./configure --prefix="$CROSS_ADDON_PREFIX" --host=$CROSS_TARGET --build=$BUILD_ARCH \
  --with-build-cc=$BUILD_GCC --enable-static --disable-shared
make $MAKEFLAGS
make install
popd > /dev/null
