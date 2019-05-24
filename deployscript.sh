#!/bin/bash



##
# USAGE: GENODE_TARGET=rpi3 bash deployscript.sh 'make jenkins_run' genode-dom0-HW/run/dom0-HW.run 02:03:03:00:00: 1 20  build/genode-rpi3 dom0-HW/uImage
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
mkdir -p $folder/var/run/batch/$i;
#Moving build to numbered folder
mv $folder/var/run/$filetosave $folder/var/run/batch/$i/;
done
echo "Done!";
