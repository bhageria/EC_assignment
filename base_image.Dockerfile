FROM arm64v8/debian:buster

RUN apt-get update && apt-get -y install --no-install-recommends \
cmake build-essential pkg-config git \
libjpeg-dev libtiff-dev libpng-dev libwebp-dev libopenexr-dev \
libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev \
libx264-dev libdc1394-22-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
libatlas-base-dev liblapacke-dev gfortran \
libhdf5-dev libhdf5-103 \
python3-dev python3-pip python3-numpy wget libgtk2.0-dev

WORKDIR /root
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

RUN mkdir /root/opencv/build
WORKDIR /root/opencv/build


RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D ENABLE_NEON=ON \
-D WITH_OPENMP=ON \
-D WITH_OPENCL=OFF \
-D BUILD_TIFF=ON \
-D WITH_FFMPEG=ON \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D WITH_GSTREAMER=ON \
-D BUILD_TESTS=OFF \
-D WITH_EIGEN=OFF \
-D WITH_V4L=ON \
-D WITH_LIBV4L=ON \
-D WITH_VTK=OFF \
-D WITH_QT=OFF \
-D WITH_GTK=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_EXAMPLES=OFF ..

RUN make -j4

# COPY ./prebuilt/ /root/opencv/build

RUN make install
RUN ldconfig

#RUN echo 'export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1' >> ~/.bashrc
#RUN source ~/.bashrc
ENV LD_PRELOAD /usr/lib/aarch64-linux-gnu/libgomp.so.1

WORKDIR /root
# RUN pip3 install gdown
#RUN wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.2.0/tensorflow-2.2.0-cp37-none-linux_aarch64.whl
RUN wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.4.0/tensorflow-2.4.0-cp37-none-linux_aarch64.whl
RUN pip3 install six wheel mock
RUN pip3 install --upgrade setuptools
RUN pip3 install keras_applications==1.0.8 --no-deps
RUN pip3 install keras_preprocessing==1.1.0 --no-deps
# This step can take an hour or more due to scipy compilation
RUN pip3 install tensorflow-2.4.0-cp37-none-linux_aarch64.whl
RUN pip3 install gpiozero

CMD [ "bash" ]
