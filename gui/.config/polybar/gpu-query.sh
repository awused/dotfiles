#!/bin/sh

nvidia-smi --query-gpu=$1 --format=csv,noheader,nounits | awk '{ print ""$1""}'


