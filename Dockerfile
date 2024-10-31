# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install prerequisites
RUN apt update && apt install -y \
    build-essential \
    debootstrap \
    binfmt-support \
    qemu-user-static

# Create and initialize ARM64 chroot environment with qemu-debootstrap
RUN qemu-debootstrap --arch arm64 buster /mnt/data/arm64 http://deb.debian.org/debian/

# Copy qemu-aarch64-static to chroot for architecture emulation
RUN cp /usr/bin/qemu-aarch64-static /mnt/data/arm64/usr/bin/

# Install additional packages within the ARM64 chroot environment
RUN chroot /mnt/data/arm64 /bin/bash -c "\
    apt update && \
    apt install -y \
        build-essential \
        git \
        wget \
        libdrm-dev \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        libopenal-dev \
        premake4 \
        autoconf \
        libevdev-dev \
        ffmpeg \
        libsnappy-dev \
        libboost-tools-dev \
        magics++ \
        libboost-thread-dev \
        libboost-all-dev \
        pkg-config \
        zlib1g-dev \
        libpng-dev \
        libsdl2-dev \
        clang \
        cmake \
        cmake-data \
        libarchive13 \
        libcurl4 \
        libfreetype6-dev \
        libjsoncpp1 \
        librhash0 \
        libuv1 \
        mercurial \
        libgbm-dev \
        libsdl2-ttf-2.0-0 \
        libsdl2-ttf-dev && \
    ln -s /usr/include/libdrm /usr/include/drm"

# Install, clone and set up Meson in the chroot
RUN chroot /mnt/data/arm64 /bin/bash -c "\
    pip3 install meson && \
    git clone https://github.com/mesonbuild/meson.git && \
    ln -s /meson/meson.py /usr/bin/meson"

# Clone libgo2 and copy headers within the chroot
RUN chroot /mnt/data/arm64 /bin/bash -c "\
    git clone https://github.com/OtherCrashOverride/libgo2.git && \
    mkdir -p /usr/include/go2 && \
    cp libgo2/src/*.h /usr/include/go2/"

# Clone rk3566_core_builds repository within the ARM64 chroot
RUN chroot /mnt/data/arm64 /bin/bash -c "\
    git clone https://github.com/christianhaitian/rk3566_core_builds.git"

# Add a script to run build.sh and copy the output
RUN echo '#!/bin/bash\n\
arg=$1\n\
chroot /mnt/data/arm64 /bin/bash -c "cd rk3566_core_builds && ./builds.sh $arg"\n\
mkdir -p /mnt/host/cores64\n\
cp /mnt/data/arm64/rk3566_core_builds/cores64/*.so /mnt/host/cores64' > /run_builds.sh

# Make the script executable
RUN chmod +x /run_builds.sh

# Set the entrypoint to the script
ENTRYPOINT ["/run_builds.sh"]
