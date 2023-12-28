FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y 

RUN apt install -y libxxf86vm-dev \ 
    software-properties-common -y \
    libxrender1 \
    libxcursor-dev \ 
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libegl-dev \
    libwayland-dev \
    wayland-protocols \
    libxkbcommon-dev \
    libsm6

RUN add-apt-repository ppa:deadsnakes/ppa -y 

RUN apt install -y python3.10 \
    python3-pip

WORKDIR /src

COPY ./whl ./tmp/whl

RUN python3 -m pip install ./tmp/whl/bpy-3.6.0-cp310-cp310-manylinux_2_28_x86_64.whl

RUN rm -rf ./tmp/whl/bpy-3.6.0-cp310-cp310-manylinux_2_28_x86_64.whl

COPY ./requirements.txt ./

RUN python3 -m pip install --no-cache-dir -r requirements.txt

COPY ./src ./src

EXPOSE 80

