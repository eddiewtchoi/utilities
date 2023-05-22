#!/bin/bash

chart=${1:-unity2-bootstrap-dependencies}

###############################################
#add .bin extension to all files that is binary
###############################################
find ${chart}/configmaps -type f | while read f ; do
  [[ ! $(file $f | grep ASCII) ]] && echo mv $f $f.bin && mv $f $f.bin 
done

echo helm upgrade --install ${chart} ./${chart}

###############################################
#remove .bin extension to all files that is binary
###############################################
find ${chart}/configmaps -type f | while read f ; do
  [[ ! $(file $f | grep ASCII) ]] && echo mv $f $(echo $f|sed 's|.bin$||g') && mv $f $(echo $f|sed 's|.bin$||g')
done

