#! /bin/bash
# Bash script to start sk108s as root
# Sigurd dagestad, 2018 
pkexec --user root /usr/bin/env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/bin/sk108s 
