target="GENODE_TARGET = focnados_pbxa9"
git checkout 18.02
git submodule update --init
make packages
make toolchain
make ports
make jenkins_build_dir $target
make jenkins_run $target
make tasks $target

