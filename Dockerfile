# Use Ubuntu 18.04 as base image
FROM ubuntu:18.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mesa-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.8.10
RUN apt-get update && \
    apt-get install -y python3.8 python3.8-dev python3-pip && \
    apt-get clean && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --set python3 /usr/bin/python3.8 && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    ln -s /usr/bin/python3 /usr/bin/python

# Install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh && \
    bash Anaconda3-2020.11-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm Anaconda3-2020.11-Linux-x86_64.sh

# Add Anaconda to PATH
ENV PATH /opt/anaconda3/bin:$PATH

# Update Anaconda
RUN conda update -n base -c defaults conda

# Set up a working directory
WORKDIR /app

# Copy code into docker container
COPY . .

# Use conda and pip to install deps
RUN conda create -n aloha python=3.8.10
RUN /bin/bash -c "source activate aloha && pip install -r requirements.txt && cd detr && pip install -e ."

RUN /bin/bash -c "echo 'source activate aloha' >> ~/.bashrc"

# Run bash
CMD ["/bin/bash"]
