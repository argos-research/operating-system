target="GENODE_TARGET = "$1
echo $target
git submodule update --init
make packages
make toolchain
rm -rf genode/contrib
make ports
make jenkins_build_dir "$target"
make tasks "$target"
make jenkins_run "$target"
cp build/genode-$1/var/run/dom0-HW/image.elf ../bin/
