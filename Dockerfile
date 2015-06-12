# This is a Dockerfile for creating a Thug https://github.com/buffer/thug Container from the latest
# Ubuntu base image. This is known bo be working on Ubuntu 14.04. It should work on any later version
# This is a full installation of Thug including all optional packages used for distributed operation
FROM ubuntu:14.04
MAINTAINER ali@ikinci.info
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV V8_HOME /usr/local/src/pyv8/build/v8_r19632
COPY requirements.txt /opt/src/

RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install --no-install-recommends \
			build-essential \
			curl \
			git \
			graphviz \
			gyp \
			libboost-python1.54.0 \
			libboost-system1.54.0 \
			libboost-thread1.54.0 \
			libemu2 \
			libffi6 \
			libpcre3 \
			librabbitmq1 \
			libtool \
			mongodb \
			mongodb-server \
			nano \
			python-lxml \
			python-pip \
			python-setuptools \
			python2.7 \
			subversion \
			# development packages
			graphviz-dev \
			libboost-dev \
			libboost-python-dev \
			libboost-system-dev \
			libboost-thread-dev \
			libemu-dev \
			libffi-dev \
			libpcre3-dev \
			python2.7-dev && \

		pip install -r /opt/src/requirements.txt && \

		# libemu
	 	git clone https://github.com/buffer/pylibemu.git /usr/local/src/pylibemu && \
		cd /usr/local/src/pylibemu && python setup.py build && \
	 	cd /usr/local/src/pylibemu && python setup.py install && \

		# thug
		git clone https://github.com/buffer/thug.git /opt/thug && \

		# PyV8 and V8
	 	svn checkout http://pyv8.googlecode.com/svn/trunk/ -r586 /usr/local/src/pyv8 && \
		svn co http://v8.googlecode.com/svn/trunk/ -r19632 /usr/local/src/pyv8/build/v8_r19632/ && \
	 	patch -d /usr/local/src/ -p0 <  /opt/thug/patches/PyV8-patch1.diff && \
	 	patch -d /usr/local/src/pyv8/build/v8_r19632/ -p1 < /opt/thug/patches/V8-patch1.diff && \
	 	cd /usr/local/src/pyv8/ && python setup.py build && \
	 	cd /usr/local/src/pyv8/ && python setup.py install && \

		# Cleanup
	 	apt-get -y remove build-essential \
			curl \
			git \
			graphviz-dev \
			gyp \
			libboost-dev \
			libboost-python-dev \
			libboost-system-dev \
			libboost-thread-dev \
			libemu-dev \
			libffi-dev \
			libpcre3-dev \
			python2.7-dev \
			subversion && \
	 	apt-get clean && apt-get autoclean && \
		apt-get -y autoremove && \
		rm -rf /var/lib/apt/lists/* /usr/local/src/pylibemu /usr/local/src/pyv8/ /opt/src/requirements.txt && \
		dpkg -l |grep ^rc |awk '{print $2}' |xargs dpkg --purge && \
	 	rm -f /opt/thug/samples/exploits/blackhole.html

COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh
ENTRYPOINT ["/usr/bin/run.sh"]
