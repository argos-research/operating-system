git checkout 18.02
git submodule update --init
make toolchain
make ports
make jenkins_build_dir "GENODE_TARGET = focnados_pbxa9"
make jenkins_run "GENODE_TARGET = focnados_pbxa9"
