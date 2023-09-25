FROM alpine:3.16 as runtime
MAINTAINER Jack Thorne <jack@kilmer.co>
ARG llvm_version
ARG gc_version
ARG crystal_targz

RUN \
  apk add --update --no-cache --force-overwrite \
    # core dependencies
    gcc gmp-dev libevent-static musl-dev pcre-dev \
    # stdlib dependencies
    libxml2-dev openssl-dev openssl-libs-static tzdata yaml-static zlib-static \
    # dev tools
    make git \
    # build libgc dependencies
    autoconf automake libtool patch

COPY .cache/bdwgc /bdwgc
RUN cd bdwgc \
    && git checkout ${gc_version} \
    \
    && ./autogen.sh \
    && ./configure --disable-debug --disable-shared --enable-large-config \
    && make -j$(nproc) CFLAGS=-DNO_GETCONTEXT \
    && make install

# RUN git clone https://github.com/ivmai/bdwgc && \
#     cd bdwgc && \
#     git checkout ${gc_version} && \
#     ./autogen.sh \
#     ./configure \
#         --disable-debug \
#         --disable-shared \
#         --enable-large-config && \
#     make -j$(nproc) CFLAGS=-DNO_GETCONTEXT && \
#     make install

# Remove build tools from image now that libgc is built
RUN apk del -r --purge autoconf automake libtool patch

COPY ${crystal_targz} /tmp/crystal.tar.gz

RUN tar -xz -C /usr \
        --strip-component=1  \
        -f /tmp/crystal.tar.gz \
        --exclude */lib/crystal/lib \
        --exclude */lib/crystal/*.a \
        --exclude */share/crystal/src/llvm/ext/llvm_ext.o && \
    rm /tmp/crystal.tar.gz

CMD ["/bin/sh"]

FROM runtime as build

ENV PATH="${PATH}:/sandbox/bin" \
    CRYSTAL_CONFIG_BUILD_COMMIT="yolo" \
    CRYSTAL_CONFIG_PATH='$ORIGIN/../share/crystal/src' \
    SOURCE_DATE_EPOCH="1000000000" \
    CC="cc -fuse-ld=lld" \
    CRYSTAL_CONFIG_LIBRARY_PATH='$ORIGIN/../lib/crystal'

RUN \
    apk add --update --no-cache --force-overwrite \
    llvm${llvm_version}-dev llvm${llvm_version}-static g++ libffi-dev \
    perf wget

ENTRYPOINT ["/bin/sh"]
