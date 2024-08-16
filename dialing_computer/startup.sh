#!/bin/bash

# Source: https://gist.github.com/rmtsrc/dc35cd1458cd995631a4f041ab11ff74

# Turn on the TV and set the input to the correct one
if [ "$1" == "on" ] || [ -z "$1" ]
then
    echo 'on 0.0.0.0' | cec-client -s -d 2
    echo 'as' | cec-client -s -d 2
fi

# Turn off the TV and set the input back to the previous one
if [ "$1" == "off" ]
then
    echo 'is' | cec-client -s -d 2
    echo 'standby 0.0.0.0' | cec-client -s -d 2
fi