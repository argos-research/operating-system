#!/bin/bash
git checkout $2
git submodule pdate --init
make packages
make toolchain
make ports
make jenkins_build_dir "GENODE_TARGET = $1"
make jenkins_run "GENODE_TARGET = $1"
