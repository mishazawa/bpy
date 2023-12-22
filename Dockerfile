FROM ubuntu:jammy as build

ARG DEBIAN_FRONTEND=noninteractive

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
  linux-libc-dev

RUN wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz

RUN tar -xf Python-3.7.6.tgz

RUN cd Python-3.7.6 && \ 
  ./configure --enable-optimizations && \
  make -j 8 && \
  make altinstall

RUN ln -s /usr/local/bin/python3.7 /usr/bin/python3

# INSTALL BLENDER

WORKDIR /blender-git
RUN git clone https://projects.blender.org/blender/blender.git 

WORKDIR /blender-git/lib

RUN svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_x86_64_glibc_228

WORKDIR /blender-git/blender

RUN apt install -y sudo
RUN ./build_files/build_environment/install_linux_packages.py

RUN make update

RUN make bpy


# FROM python:3.7.6-slim as target

# WORKDIR /src

# COPY ./requirements.txt ./

# RUN pip install --no-cache-dir -r requirements.txt

# COPY ./src ./src

# CMD [ "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80", "--reload"]