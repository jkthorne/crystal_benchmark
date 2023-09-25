ARG crystal_version=1.6.1
ARG llvm_version=13

FROM wontruefree/crystal:${crystal_version}-${llvm_version} as runtime

ENV PATH="${PATH}:/sandbox/bin" \
    CRYSTAL_CONFIG_BUILD_COMMIT="yolo" \
    CRYSTAL_CONFIG_PATH='$ORIGIN/../share/crystal/src' \
    SOURCE_DATE_EPOCH="1000000000" \
    CC="cc -fuse-ld=lld" \
    CRYSTAL_CONFIG_LIBRARY_PATH='$ORIGIN/../lib/crystal'

COPY crystal /crystal
WORKDIR /crystal

RUN git reset --hard  && \
    git clean -df && \
    git checkout 1.6.1 && \
    make clean > /dev/null && \
    make deps > /dev/null && \
    mkdir .build

COPY benchmark ./benchmark
ENTRYPOINT ["/crystal/benchmark"]
