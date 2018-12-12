target="GENODE_TARGET = "$1
echo $target
git submodule update --init
make packages
make toolchain
make ports
make jenkins_build_dir "$target"
make tasks "$target"
make jenkins_run "$target"
cp build/genode-focnados_panda/var/run/dom0-HW/image.elf ../bin/image.elf
