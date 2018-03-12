PROJECT		?= dom0-HW

# options: x86 arm
TOOLCHAIN_TARGET    ?= arm

# options: see tool/create_builddir
GENODE_TARGET       ?= focnados_panda

ifneq (,$(findstring if13praktikum, $(shell groups)))
	VAGRANT_BUILD_DIR         ?= $(shell pwd)/build
else
	VAGRANT_BUILD_DIR         ?= /build
endif
VAGRANT_TOOLCHAIN_BUILD_DIR ?= $(VAGRANT_BUILD_DIR)/toolchain-$(TOOLCHAIN_TARGET)
VAGRANT_GENODE_BUILD_DIR    ?= $(VAGRANT_BUILD_DIR)/genode-$(GENODE_TARGET)
VAGRANT_BUILD_CONF           = $(VAGRANT_GENODE_BUILD_DIR)/etc/build.conf
VAGRANT_TOOLS_CONF           = $(VAGRANT_GENODE_BUILD_DIR)/etc/tools.conf

JENKINS_BUILD_DIR           ?= build
JENKINS_TOOLCHAIN_BUILD_DIR ?= $(JENKINS_BUILD_DIR)/toolchain-$(TOOLCHAIN_TARGET)
JENKINS_GENODE_BUILD_DIR    ?= $(JENKINS_BUILD_DIR)/genode-$(GENODE_TARGET)
JENKINS_BUILD_CONF           = $(JENKINS_GENODE_BUILD_DIR)/etc/build.conf
JENKINS_TOOLS_CONF = $(JENKINS_GENODE_BUILD_DIR)/etc/tools.conf

vagrant: ports build_dir

jenkins: foc jenkins_build_dir

# ================================================================
# Genode toolchain. Only needs to be done once per target (x86/arm).
toolchain:
	wget https://nextcloud.os.in.tum.de/s/9idiw8BLbuwp35z/download -O toolchain
	tar xfj toolchain -C .
#
# ================================================================


# ================================================================
# Download Genode external sources. Only needs to be done once per system.
ports: foc libports dde_linux

foc:
	./genode/tool/ports/prepare_port focnados

libports:
	./genode/tool/ports/prepare_port libc
	./genode/tool/ports/prepare_port lwip
	./genode/tool/ports/prepare_port stdcxx

dde_linux:
	./genode/tool/ports/prepare_port dde_linux
#
# ================================================================


# ================================================================
# Genode build process. Rebuild subtargets as needed.

build_dir:
	genode/tool/create_builddir $(GENODE_TARGET) BUILD_DIR=$(VAGRANT_GENODE_BUILD_DIR)
	printf 'REPOSITORIES += $$(GENODE_DIR)/repos/libports\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-dom0-HW\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Taskloader\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Parser\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Monitoring\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-schedulerTest\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-AdmCtrl\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Synchronization\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Utilization\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../toolchain-host\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-CheckpointRestore-SharedMemory\n' >> $(VAGRANT_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/repos/dde_linux\n' >> $(VAGRANT_BUILD_CONF)
	printf 'MAKE += -j4' >> $(VAGRANT_BUILD_CONF)
ifneq (,$(findstring if13praktikum, $(shell groups)))
	printf 'CROSS_DEV_PREFIX=/var/tmp/usr/local/genode-gcc/bin/genode-arm-\n' >> $(VAGRANT_TOOLS_CONF)
endif

jenkins_build_dir:
	genode/tool/create_builddir $(GENODE_TARGET) BUILD_DIR=$(JENKINS_GENODE_BUILD_DIR)
	printf 'REPOSITORIES += $$(GENODE_DIR)/repos/libports\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-dom0-HW\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Taskloader\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Parser\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Monitoring\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-schedulerTest\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-AdmCtrl\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Synchronization\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-Utilization\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../toolchain-host\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/../genode-CheckpointRestore-SharedMemory\n' >> $(JENKINS_BUILD_CONF)
	printf 'REPOSITORIES += $$(GENODE_DIR)/repos/dde_linux\n' >> $(JENKINS_BUILD_CONF)
	printf 'MAKE += -j' >> $(JENKINS_BUILD_CONF)
	echo "CROSS_DEV_PREFIX=$(shell pwd)/usr/local/genode-gcc/bin/genode-arm-" >> $(JENKINS_TOOLS_CONF)


# Delete build directory for all target systems. In some cases, subfolders in the contrib directory might be corrupted. Remove manually and re-prepare if necessary.
clean:
	rm -rf $(VAGRANT_GENODE_BUILD_DIR)

jenkins_clean:
	rm -rf $(JENKINS_GENODE_BUILD_DIR)
#
# ================================================================


# ================================================================
# Run Genode with an active dom0 server.
run:
	$(MAKE) -C $(VAGRANT_GENODE_BUILD_DIR) run/$(PROJECT) #declare which run file to run
	rm -f /var/lib/tftpboot/image.elf
	rm -f /var/lib/tftpboot/modules.list
	rm -rf /var/lib/tftpboot/genode
	cp $(VAGRANT_GENODE_BUILD_DIR)/var/run/$(PROJECT)/image.elf /var/lib/tftpboot/
	cp $(VAGRANT_GENODE_BUILD_DIR)/var/run/$(PROJECT)/modules.list /var/lib/tftpboot/
	cp -R $(VAGRANT_GENODE_BUILD_DIR)/var/run/$(PROJECT)/genode /var/lib/tftpboot/

jenkins_run:
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) run/$(PROJECT) #declare which run file to run
	rm -f /var/lib/tftpboot/image.elf
	rm -f /var/lib/tftpboot/modules.list
	rm -rf /var/lib/tftpboot/genode
	cp $(JENKINS_GENODE_BUILD_DIR)/var/run/$(PROJECT)/image.elf /var/lib/tftpboot/
	cp $(JENKINS_GENODE_BUILD_DIR)/var/run/$(PROJECT)/modules.list /var/lib/tftpboot/
	cp -R $(JENKINS_GENODE_BUILD_DIR)/var/run/$(PROJECT)/genode /var/lib/tftpboot/

#
# ================================================================

# ================================================================
# Requiered packages for relaunched systems
packages:
	sudo apt-get update
	sudo apt-get install libncurses5-dev texinfo autogen autoconf2.64 g++ libexpat1-dev flex bison gperf cmake libxml2-dev libtool zlib1g-dev libglib2.0-dev make pkg-config gawk subversion expect git libxml2-utils syslinux xsltproc yasm iasl lynx unzip qemu
#
# ================================================================

# ================================================================
# VDE setup. Do once per system session. DHCP is optional.
vde: vde-stop
	@vde_switch -d -s /tmp/switch1 -M /tmp/mgmt
	@sudo vde_tunctl -u $(USER) -t tap0
	@sudo ip link set dev tap0 address 76:5e:06:6a:7e:87
	@sudo ifconfig tap0 10.200.40.10 up
	@vde_plug2tap --daemon -s /tmp/switch1 tap0

vde-stop:
	@-pkill vde_switch
	@-sudo vde_tunctl -d tap0
	@-rm -rf /tmp/switch1

#Needs rework to use isc-dhcp instead
dhcp: dhcp-stop
	@slirpvde -d -s /tmp/switch1 -dhcp

dhcp-stop:
	@-pkill slirpvde

# Cleanup network shenanigans.
clean-network: dhcp-stop vde-stop
#
# ================================================================

# ================================================================
# Compile task for toolchain host
tasks:
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) cond_42
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) cond_mod
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) hey
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) idle
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) linpack
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) namaste
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) pi
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) tumatmul
	cp $(JENKINS_GENODE_BUILD_DIR)/cond_42/cond_42 toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/cond_mod/cond_mod toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/hey/hey toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/idle/idle toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/linpack/linpack toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/namaste/namaste toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/pi/pi toolchain-host/host_dom0
	cp $(JENKINS_GENODE_BUILD_DIR)/tumatmul/tumatmul toolchain-host/host_dom0
