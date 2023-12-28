FROM ubuntu:jammy as build

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VER_FULL=3.7.2
ARG PYTHON_VER_MAJ=3.7
ARG BLENDER_VERSION=3.6

ENV PYTHON_SITE_PACKAGES /usr/local/lib/python$PYTHON_VER_MAJ/site-packages/
ENV WITH_INSTALL_PORTABLE OFF

RUN apt update && apt upgrade -y

RUN apt install -y build-essential \
  zlib1g-dev \
  libncurses5-dev \
  libgdbm-dev \
  libnss3-dev \
  libssl-dev \
  libsqlite3-dev \
  libreadline-dev \
  libffi-dev \
  wget \
  libbz2-dev \
  git\
  subversion \
  cmake \ 
  libx11-dev \
  libxxf86vm-dev \
  libxcursor-dev \ 
  libxi-dev \
  libxrandr-dev \
  libxinerama-dev \
  libegl-dev \
  libwayland-dev \
  wayland-protocols \
  libxkbcommon-dev \
  libdbus-1-dev \
  linux-libc-dev \
  sudo

WORKDIR /tmp/python
RUN wget https://www.python.org/ftp/python/$PYTHON_VER_FULL/Python-$PYTHON_VER_FULL.tgz
RUN tar -xf Python-$PYTHON_VER_FULL.tgz

WORKDIR /tmp/python/Python-$PYTHON_VER_FULL 
RUN ./configure --enable-optimizations
RUN make -j$(nproc)
RUN make altinstall

RUN ln -s /usr/local/bin/python$PYTHON_VER_MAJ /usr/bin/python3
RUN apt install -y python3-setuptools python3-pip
RUN python3 -m pip install wheel

COPY ./tmp /tmp

# INSTALL BLENDER
WORKDIR /tmp/lib
#RUN svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_x86_64_glibc_228

WORKDIR /tmp
#RUN git clone --depth 1 --branch v3.6.7 https://projects.blender.org/blender/blender.git 

WORKDIR /tmp/blender/build_files/build_environment

RUN ./install_linux_packages.py

WORKDIR /tmp/blender
RUN make update
RUN make bpy -j4

RUN ./build_files/utils/make_bpy_wheel.py ../build_linux_bpy/bin/ --output-dir=/out

WORKDIR /out
CMD bash
