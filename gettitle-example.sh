#!/bin/bash

# Returns a video title extracted from the filename which is given as the
# command line parameter to this script.

t=$*

# Remove until first dot.
t=${t#*.}

# Remove further dots.
echo ${t//./ }
