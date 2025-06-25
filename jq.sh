#!/bin/bash

wget -q -O jq /https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux-amd64
sudo mv jq /usr/local/bin
sudo chmod +x /usr/local/bin/jq

export JQ_COLORS="38;2;255;173;173:38;2;255;214;165:38;2;253;255;182:38;2;202;255;191:38;2;155;246;255:38;2;160;196;255:38;2;189;178;255:38;2;255;198;255"
