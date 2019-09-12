#!/bin/bash



##
# This script helps you build different versions of Genode images. It was used to generate genode rpi2/3 images, which where then transferred to a TFTP-Server directory from where they are send to the hardware
#components when requested. Other than genode images that are used in MaLSAMi, these images need each a different MAC address to get the correct TFTP instructions as well as the correct IP from the DHCP server.
#The script can also be reused to build images with other configurational requirements. If yu want to do so, please adopt line 30 (sed command) and following accordingly

# Description of the subparts
#         SET build target                     select command to execute   file to change mac address in     mac address prefix  build start value  build end value   build image to move
# USAGE: GENODE_TARGET=rpi3 bash deployscript.sh 'make jenkins_run'        genode-dom0-HW/run/dom0-HW.run    02:03:03:00:00:     1                  20                build/genode-rpi3 dom0-HW/uImage
##

commando=$1;
filetochange=$2;
mac=$3;
starto=$4;
endo=$5;
folder=$6;
filetosave=$7;


for i in $(seq $starto $endo)
do
    echo "run $i";
    #create hex from dec
    k=$(printf "%02x\n" $i);

sed -i "s/mac=\".*\"/mac=\"$mac$k\"/" $filetochange;
cat $filetochange | grep mac;
#running command
$commando;
#Generating folder for current build
z=$(printf "%02d" $i) 
mkdir -p $folder/var/run/batch/$z;
#Moving build to numbered folder
mv $folder/var/run/$filetosave $folder/var/run/batch/$i/;
done
echo "Done!";
