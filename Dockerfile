ARG CUDA_VERSION="11.8.0"
ARG CUDNN_VERSION="8"
ARG UBUNTU_VERSION="22.04"

FROM nvidia/cuda:$CUDA_VERSION-cudnn$CUDNN_VERSION-devel-ubuntu$UBUNTU_VERSION

ENV PATH="/root/miniconda3/bin:${PATH}"

ARG PYTHON_VERSION="3.9"
ENV PYTHON_VERSION=$PYTHON_VERSION

# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda init bash \
    && source /root/.bashrc \
    && conda update conda \
    && conda create -n "py${PYTHON_VERSION}" python="${PYTHON_VERSION}" \
    && echo "source activate py${PYTHON_VERSION}" > ~/.bashrc

WORKDIR /workspace

CMD [ "/bin/bash" ]