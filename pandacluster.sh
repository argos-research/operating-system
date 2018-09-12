make jenkins_run
scp build/genode-focnados_panda/var/run/dom0-HW/image.elf reisner@supermvs:/var/lib/tftpboot/pandaboard/pandacluster/01
sed -i 's/02:02:00:00:00:01/02:02:00:00:00:02/g' genode-dom0-HW/run/dom0-HW.run
make jenkins_run
scp build/genode-focnados_panda/var/run/dom0-HW/image.elf reisner@supermvs:/var/lib/tftpboot/pandaboard/pandacluster/02
sed -i 's/02:02:00:00:00:02/02:02:00:00:00:03/g' genode-dom0-HW/run/dom0-HW.run
make jenkins_run
scp build/genode-focnados_panda/var/run/dom0-HW/image.elf reisner@supermvs:/var/lib/tftpboot/pandaboard/pandacluster/03
sed -i 's/02:02:00:00:00:03/02:02:00:00:00:04/g' genode-dom0-HW/run/dom0-HW.run
make jenkins_run
scp build/genode-focnados_panda/var/run/dom0-HW/image.elf reisner@supermvs:/var/lib/tftpboot/pandaboard/pandacluster/04
sed -i 's/02:02:00:00:00:04/02:02:00:00:00:01/g' genode-dom0-HW/run/dom0-HW.run
