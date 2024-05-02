
# Use an Ubuntu base image
FROM cimg/node:16.16

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites for nvm, Node.js, and ldid
RUN sudo apt-get update && sudo apt-get install -y \
	curl \
	git \
	build-essential \
	checkinstall \
	autoconf \
	automake \
	libtool-bin \
	doxygen \
	qemu-user-static \
	binfmt-support \
	libssl-dev \
	libplist-dev \
	mlocate \
	bash \
	python3 \
	cython3 \
	python3-pip \
	&& sudo rm -rf /var/lib/apt/lists/*

RUN export PATH="/usr/local/bin/python3:$PATH"
RUN sudo ln -s /usr/bin/python3 /usr/bin/python
# Installing liblist
RUN git clone https://github.com/libimobiledevice/libplist.git /tmp/libplist && \
	cd /tmp/libplist \
	&& ./autogen.sh --prefix=/usr/local --enable-debug \
	&& ./configure --prefix=/usr/local --enable-debug \
	&& make \
	&& sudo make install

RUN rm -rf /tmp/liblist


RUN pkg-config --variable pc_path pkg-config
RUN echo 'export CPLUS_INCLUDE_PATH=/usr/include:$CPLUS_INCLUDE_PATH' >> ~/.bashrc
RUN export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
RUN sudo ldconfig
RUN source ~/.bashrc

#installing LDID
RUN git clone https://github.com/ProcursusTeam/ldid.git /tmp/ldid && \
	cd /tmp/ldid && \
	make && \
	sudo make install

run rm -rf /tmp/ldid

# Set work directory
WORKDIR /app
