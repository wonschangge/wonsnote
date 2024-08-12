ip addr | awk '/inet.*global/ {print $2"\b\b\b   "}'
ip addr | awk '/inet.*global/ {print $2}' | sed 's/\/.*//'