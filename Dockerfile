FROM ubuntu:19.10

LABEL version="1.0"
LABEL maintainer="Kirill Vladimirov"

ENV NAME rbc-ml-lab
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apt-get update && apt-get install -y \
		python3.6 \
		python3-pip \
		bc \
		build-essential \
		make \
		cmake \
		libboost-all-dev \
		curl \
		g++ \
		gfortran \
		git \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
		nano \
		pkg-config \
		python-dev \
		software-properties-common \
		unzip \
		unrar \
		vim \
		wget \
		zlib1g-dev \
		qt5-default \
		libvtk6-dev \
		zlib1g-dev \
		libjpeg-dev \
		libwebp-dev \
		libpng-dev \
		libtiff5-dev \
		libopenexr-dev \
		libgdal-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libtheora-dev \
		libvorbis-dev \
		libxvidcore-dev \
		libx264-dev \
		yasm \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libv4l-dev \
		libxine2-dev \
		libtbb-dev \
		libeigen3-dev \
		python-dev \
		python-tk \
		python-numpy \
		python3-dev \
		python3-tk \
		python3-numpy \
		ant \
		default-jdk \
		doxygen \
		tree\
		tzdata \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* 

RUN dpkg-reconfigure --frontend noninteractive tzdata

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

# RUN pip3 install -U nltk
# RUN python3 -m nltk.downloader -q all
# RUN pip3 install -U numpy

# Script to install BigARTM on Ubuntu
RUN pip3 install protobuf tqdm wheel
RUN git clone --branch=stable https://github.com/bigartm/bigartm.git
RUN cd bigartm && mkdir build && cd build && cmake -DPYTHON=python3 -DCMAKE_INSTALL_PREFIX=/opt/bigartm ..
RUN cd bigartm/build &&  make
RUN cd bigartm/build && make install
RUN export ARTM_SHARED_LIBRARY=/usr/local/lib/libartm.so
RUN pip3 install bigartm/build/python/bigartm*.whl

RUN pip3 install topicnet

RUN mkdir work

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
