FROM arm32v7/debian:buster

# RUN apt-get update && apt-get install -no-install-recommends \
# 	gcc \
# 	g++ \
# 	gfortran \
# 	libopenblas-dev \
# 	libblas-dev \
# 	liblapack-dev \
# 	libatlas-base-dev \
# 	libhdf5-dev \
# 	libhdf5-103 \
# 	pkg-config \
# 	python3 \
# 	python3-dev \
# 	python3-pip \
# 	python3-setuptools \
# 	pybind11-dev \
# 	wget unzip build-essential libjpeg-dev libpng-dev libtiff-dev \
#     libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
#     libxvidcore-dev libx264-dev libgtk2.0-dev \
#     cmake libgtk-3-dev libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5 

RUN apt-get update && apt-get -y install --no-install-recommends \
cmake build-essential pkg-config git \
libjpeg-dev libtiff-dev libpng-dev libwebp-dev libopenexr-dev \
libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev \
libx264-dev libdc1394-22-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
libatlas-base-dev liblapacke-dev gfortran \
libhdf5-dev libhdf5-103 \
python3-dev python3-pip python3-numpy

WORKDIR /home
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

RUN mkdir /home/opencv/build
WORKDIR /home/opencv/build


RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/home/opencv_contrib/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D CMAKE_SHARED_LINKER_FLAGS=-latomic \
    -D BUILD_EXAMPLES=OFF ..

RUN make -j$(nproc)

RUN make install
RUN ldconfig
