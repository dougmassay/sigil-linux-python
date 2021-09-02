#! /bin/bash

set -ex

# Download, compile, and install openssl
wget --no-check-certificate -q "https://www.openssl.org/source/openssl-${OPENSSL}.tar.gz"
tar zxf "openssl-${OPENSSL}.tar.gz"
pushd "openssl-${OPENSSL}"
./config no-ssl2 no-ssl3 shared -fPIC --prefix="$OPENSSL_DIR"
make depend
make -j"$(nproc)"
if [[ "${OPENSSL}" =~ 1.0.1 ]]; then
    # OpenSSL 1.0.1 doesn't support installing without the docs.
    make install
else
    # Avoid installing the docs
    make install_sw install_ssldirs
fi
popd

wget --no-check-certificate -q "https://sourceforge.net/projects/tcl/files/Tcl/${TCLTK}/tcl${TCLTK}-src.tar.gz"
tar zxf "tcl${TCLTK}-src.tar.gz"
pushd "tcl${TCLTK}/unix"
./configure --enable-threads --prefix="$TCL_DIR"
make -j"$(nproc)"
make install
popd

wget --no-check-certificate -q "https://sourceforge.net/projects/tcl/files/Tcl/${TCLTK}/tk${TCLTK}-src.tar.gz"
tar zxf "tk${TCLTK}-src.tar.gz"
pushd "tk${TCLTK}/unix"
./configure --with-tcl=/work/tcl${TCLTK}/unix --prefix="$TK_DIR"
make -j"$(nproc)"
make install
popd
