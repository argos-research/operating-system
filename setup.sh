target="GENODE_TARGET = focnados_pbxa9"
echo $target
git submodule update --init
make packages
make toolchain
make ports
make jenkins_build_dir "$target"
make tasks "$target"
make jenkins_run "$target"
