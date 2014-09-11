# This is a Dockerfile for creating a Thug https://github.com/buffer/thug Container from the latest
# Ubuntu base image. This is known bo be working on Ubuntu 14.04. It should work on any later version
# This is a full installation of Thug including all optional packages used for distributed operation
FROM ubuntu:14.04
MAINTAINER ali@ikinci.info
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
# All commands are executed in one line to downsize the resulting docker image resulting in a 60% - 70% size savings
RUN apt-get update && apt-get -y dist-upgrade && \
	apt-get -y install --no-install-recommends graphviz librabbitmq1 nano python-chardet python-cssutils python-html5lib python-httplib2 libemu2 python-lxml python-magic python-pika python-pip python-pydot python-pymongo python-pyparsing python-requests python-yara python-zope.interface vim build-essential curl git gyp libboost-python-dev libboost-thread-dev libboost-system-dev python-dev subversion libemu-dev && \
	pip install -q jsbeautifier rarfile beautifulsoup4 pefile && \
	svn checkout http://pyv8.googlecode.com/svn/trunk/ /usr/local/src/pyv8 && \
	curl -s https://raw.githubusercontent.com/buffer/thug/master/patches/PyV8-patch1.diff -o /usr/local/src/PyV8-patch1.diff && \
	patch -d /usr/local/src/ -p0 < /usr/local/src/PyV8-patch1.diff && \
	cd /usr/local/src/pyv8/ && python setup.py build && \
	cd /usr/local/src/pyv8/ && python setup.py install && \
	git clone https://github.com/buffer/pylibemu.git /usr/local/src/pylibemu && \
	cd /usr/local/src/pylibemu && python setup.py build && \
	cd /usr/local/src/pylibemu && python setup.py install && \
	git clone https://github.com/buffer/thug.git /opt/thug && \
	apt-get clean && apt-get autoclean && \
	rm -rf /usr/local/src/pylibemu /usr/local/src/pyv8/ /usr/local/src/PyV8-patch1.diff  && \
	apt-get -y remove build-essential curl git gyp python-dev subversion libemu-dev  && \
	apt-get -y autoremove && \
	dpkg -l |grep ^rc |awk '{print $2}' |xargs dpkg --purge
