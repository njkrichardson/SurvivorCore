# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS base

WORKDIR /circuit_design

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    autoconf \
	libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    graphviz \
    xdot \
    pkg-config \
    libboost-system-dev \
	libboost-python-dev \
    libboost-filesystem-dev \
    zlib1g-dev \
    bison \
    clang \
    build-essential \
    nodejs \
    flex \
    gdb \
    gperf \
    direnv \
    zsh \
    wget \
    curl \
    git \
    cmake \
    unzip \
    parallel \ 
    python3-venv \
    python3-pip \
    vim 

# configure zsh 
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t af-magic \
    -p git \
    -p vi-mode 

RUN cd / \
	&& git clone https://github.com/njkrichardson/dots.git \
	&& parallel cp dots/.zshrc ::: /.zshrc ~/.zshrc \
	&& cp dots/.vimrc /root/.vimrc \
	&& echo "export XDG_CONFIG_HOME=/.config" >> /.zshrc \
	&& echo "export XDG_CONFIG_HOME=/.config" >> ~/.zshrc

# install icarus verilog 
RUN cd / \
    && git clone https://github.com/steveicarus/iverilog.git \
    && cd iverilog \
    && sh autoconf.sh \
    && ./configure \
    && make \
    && make install

# install yosys 
RUN cd / \
    && git clone https://github.com/YosysHQ/yosys.git \
    && cd yosys \
    && make \
    && make install

# install netlistsvg 
RUN cd / \
    && git clone https://github.com/nturley/netlistsvg \
    && cd netlistsvg \
    && npm install \
    && npm install -g .

CMD ["/bin/zsh"]
