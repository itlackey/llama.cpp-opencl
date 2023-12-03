# Start with Ubuntu 23.10 as base image
FROM ubuntu:23.10

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Install necessary dependencies
#RUN apt install -y wget gpg curl build-essential cmake git libopencl1 ocl-icd-opencl-dev clblast-utils opencl-headers ocl-icd libclblast-dev
RUN apt-get install -y wget gpg curl build-essential cmake git opencl-headers

# Add Intel's package repository
RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
  gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg && \
  echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client" | \
  tee /etc/apt/sources.list.d/intel-gpu-jammy.list && \
  apt-get update

# Install the user-mode packages
RUN apt-get install -y \
  intel-opencl-icd intel-level-zero-gpu level-zero \
  intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
  libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
  libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
  mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vainfo hwinfo clinfo

WORKDIR /opt


RUN apt install -y libopencl1 ocl-icd-opencl-dev clblast-utils opencl-headers libclblast-dev

# Install CLBlast
RUN git clone https://github.com/CNugteren/CLBlast.git && \
    mkdir CLBlast/build && \
    cd CLBlast/build && \
    cmake .. -DBUILD_SHARED_LIBS=OFF -DTUNERS=OFF && \
    cmake --build . --config Release && \
    cmake --install . --prefix /usr/local/ && \
    cd /opt

# Clone and build Llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp.git
WORKDIR /opt/llama.cpp

# Build the project with CLBlast
RUN mkdir build && cd build && cmake .. -DLLAMA_CLBLAST=ON -DCLBlast_DIR=/usr/local && cmake --build . --config Release

RUN apt-get install -y pciutils

WORKDIR /opt/llama.cpp/build/bin

#ENTRYPOINT [ "/opt/llama.cpp/build/bin/server", "-m /models/wizardlm-1.0-uncensored-llama2-13b.Q5_K_M.gguf -c 2048 --port 3000" ]