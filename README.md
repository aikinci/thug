Thug
====

A dockerized Thug https://github.com/buffer/thug . Thug version 0.5.1

Get it from the Honeynet Project's Docker repository https://registry.hub.docker.com/u/honeynet/thug/

This automated build is kindly maintained by Ali Ikinci https://github.com/aikinci/thug


Thug is installed at /opt/thug . To run run it execute python /opt/thug/src/thug.py

Example usage:

Download latest container

    docker pull honeynet/thug

This will mount your hosts ~/logs dir and enable to keep the logs on the host

    docker run -it -v ~/logs:/logs honeynet/thug  /bin/bash

inside the container run this to analyze 20 random samples from thug 

    for item in  $(find /opt/thug/samples/ -type f  |xargs shuf -e |tail -n 20); do python /opt/thug/src/thug.py -l  $item; done
