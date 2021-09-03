FROM quay.io/pypa/manylinux2014_x86_64:2021-08-31-6f90a75
LABEL maintainer="https://github.com/dougmassay"

ARG Arch=x86_64
ENV ARCH="${Arch}"                                                             \
    OPENSSL="1.1.1l"                                                           \
    TCLTK="8.6.11"

RUN yum -y install bzip2-devel fuse-sshfs gdbm-devel ncurses-devel libffi-devel \
                   readline-devel sqlite-devel openssl-devel symlinks tk-devel  \
                   xz-devel wget

COPY . /work
WORKDIR /work
SHELL ["/bin/bash", "-c"]

ENV OPENSSL_DIR="${HOME}/openssl/${OPENSSL}"                                    \
    TCL_DIR="${HOME}/tcl/${TCLTK}"                                              \
    TK_DIR="${HOME}/tk/${TCLTK}"

RUN ./install.sh

ENV PATH="${OPENSSL_DIR}/bin:${PATH}"                                                       \
    CFLAGS="${CFLAGS} -I${OPENSSL_DIR}/include -I${TCL_DIR}/include -I${TK_DIR}/include"    \
    LDFLAGS="-L${OPENSSL_DIR}/lib -L${TCL_DIR}/lib -L${TK_DIR}/lib"                         \
    LD_LIBRARY_PATH="${OPENSSL_DIR}/lib:${TCL_DIR}/lib:${TK_DIR}/lib:${LD_LIBRARY_PATH}"

CMD ["./script.sh", "--appdir", "AppDir"]
