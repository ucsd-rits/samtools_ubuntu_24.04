FROM ubuntu:noble

# Metadata
LABEL maintainer="UC San Diego Research IT Services Ian Kaufman <ikaufman@ucsd.edu>"
LABEL description="Docker image based on Ubuntu 24.04"

# 2) change to root to install packages
USER root

# Set up some CUDA environment vars
#ARG LIBNVINFER=7.2.2 LIBNVINFER_MAJOR_VERSION=7 CUDA_VERSION=11.8

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS="yes"

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl wget vim git htop \
    zlib1g zlib1g-dev libperl-dev bzip2 libbz2-dev liblzma-dev libcurl4t64 libcurl4-openssl-dev \
    build-essential autoconf automake autotools-dev m4 libgsl-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install samtools
USER $NB_UID:$NB_GID
RUN mkdir build; cd build
RUN git clone --recurse-submodules https://github.com/samtools/htslib.git
RUN git clone https://github.com/samtools/bcftools.git
RUN cd bcftools
RUN  autoheader && autoconf && ./configure --enable-libgsl --enable-perl-filters
RUN make
# RUN export BCFTOOLS_PLUGINS=/path/to/bcftools/plugins

RUN pip install --no-cache-dir networkx scipy

# Set up working directory
WORKDIR /app

# Copy application files (if applicable)
# COPY . /app

# Expose ports (if applicable)
# EXPOSE 8080

# Define the command to run when the container starts
# CMD ["/bin/bash"]
