#!/bin/sh

nvidia-smi --query-gpu=$1 --format=csv,noheader,nounits | tail -n1 | awk '{ print ""$1""}'


