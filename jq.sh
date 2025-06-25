#!/bin/bash

# Download jq binary
wget -q -O jq-linux-amd64 https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux-amd64

# Move to /usr/local/bin  
sudo mv jq-linux-amd64 /usr/local/bin/jq

# Set permissions
sudo chmod +x /usr/local/bin/jq

# Set JQ_COLORS environment variable for truecolor support
export JQ_COLORS="38;2;255;173;173:38;2;255;214;165:38;2;253;255;182:38;2;202;255;191:38;2;155;246;255:38;2;160;196;255:38;2;189;178;255:38;2;255;198;255"

# Test jq with colors
jq -nc '[null,false,true,42,{"a":"bc"}]'
