FROM --platform=linux/amd64 ubuntu:22.04 
# included '--platform=linux/amd64' for M1 compatibility.

# Set env. variables.
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get clean && \
    apt-get update && apt-get install --no-install-recommends -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

# Install Python, xvfb, other stuff.
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    build-essential \
    byobu \
    curl \
    git-core \
    htop \
    pkg-config \
    python3-pip \
    python3-dev \
    python3-gi \
    python3-setuptools \
    python3-wheel \
    unzip \
    freeglut3-dev \
    xvfb \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Anaconda.
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

# Create development environment
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
RUN conda create --name dev python=3.8
RUN conda activate dev

# Install stable-retro, tianshou
RUN pip3 install --no-cache-dir git+https://github.com/MatPoliquin/stable-retro.git
RUN conda install tianshou

# Setup Filesystem.
ENV SHELL=/bin/bash
WORKDIR /code

# Setup Display
ENV DISPLAY :0
ENV VGL_REFRESHRATE 60
ENV VGL_ISACTIVE 1
ENV VGL_DISPLAY egl
ENV VGL_WM 1

ENTRYPOINT ["/bin/bash"]
