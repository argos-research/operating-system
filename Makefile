PROJECT		?= dom0-HW

# options: x86 arm
TOOLCHAIN_TARGET    ?= arm

# options: see tool/create_builddir
GENODE_TARGET       ?= focnados_panda

JENKINS_BUILD_DIR           ?= build
JENKINS_TOOLCHAIN_BUILD_DIR ?= $(JENKINS_BUILD_DIR)/toolchain-$(TOOLCHAIN_TARGET)
JENKINS_GENODE_BUILD_DIR    ?= $(JENKINS_BUILD_DIR)/genode-$(GENODE_TARGET)
JENKINS_BUILD_CONF           = $(JENKINS_GENODE_BUILD_DIR)/etc/build.conf
JENKINS_TOOLS_CONF = $(JENKINS_GENODE_BUILD_DIR)/etc/tools.conf

jenkins: foc jenkins_build_dir

# ================================================================
# Genode toolchain. Only needs to be done once per target (x86/arm).
toolchain:
	wget -qO- https://nextcloud.os.in.tum.de/s/oHeGQp3rVk5MPpQ/download | tar xfJ -
#
# ================================================================


# ================================================================
# Download Genode external sources. Only needs to be done once per system.
PORTS_LST = focnados libc lwip stdcxx dde_linux
ports:
ifeq (jenkins, $(USER))
	./genode/tool/ports/prepare_port -j $(PORTS_LST)
else
	./genode/tool/ports/prepare_port -j4 $(PORTS_LST)
endif
#
# ================================================================


# ================================================================
# Genode build process. Rebuild subtargets as needed.

# ================================================================
# Link the genode-world repository into genode/repos/world.
world:
	ln -sfn $(shell pwd)/genode-world $(shell pwd)/genode/repos/world
#
# ================================================================

CUSTOM_REPOS = $(wildcard genode-*) $(wildcard ../genode-*) toolchain-host

jenkins_build_dir: world
#	Create build directory
	genode/tool/create_builddir $(GENODE_TARGET) BUILD_DIR=$(JENKINS_GENODE_BUILD_DIR)

#	Uncomment libports and dde_linux from etc/build.conf
	for repo in libports dde_linux world ; do \
		sed -i "/$$repo/s/^#REPOSITORIES/REPOSITORIES/g" $(JENKINS_BUILD_CONF) ; \
	done

#	Comment default start with display from etc/build.conf
	for opt in "-display sdl"; do \
	sed -i "/$$opt/s/^/#/g" $(JENKINS_BUILD_CONF) ; \
	done

#	Add our custom repositories to etc/build.conf
	for repo in $(CUSTOM_REPOS); do \
		echo "REPOSITORIES += \$$(GENODE_DIR)/../$$repo" >> $(JENKINS_BUILD_CONF) ; \
	done

#	Speedup of the build process
ifeq (jenkins, $(USER))
	echo "MAKE += -j" >> $(JENKINS_BUILD_CONF)
else
	echo "MAKE += -j4" >> $(JENKINS_BUILD_CONF)
endif

#	Add toolchain path to etc/specs.conf
	echo "CROSS_DEV_PREFIX=$(shell pwd)/usr/local/genode-gcc/bin/genode-arm-" >> $(JENKINS_TOOLS_CONF)


# Delete build directory for all target systems. In some cases, subfolders in the contrib directory might be corrupted. Remove manually and re-prepare if necessary.
jenkins_clean:
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) cleanall
#
# ================================================================


# ================================================================
# Run Genode with an active dom0 server.
jenkins_run:
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) run/$(PROJECT) #declare which run file to run

#
# ================================================================

# ================================================================
# Run Genode with an active dom0 server.
jenkins_just_build:
	$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) $(PROJECT) #declare which run file to run

#
# ================================================================

# ================================================================
# Requiered packages for relaunched systems
packages:
	sudo apt-get update -qq
	sudo apt-get install -qq libncurses5-dev texinfo autogen autoconf2.64 g++ libexpat1-dev \
			     flex bison gperf cmake libxml2-dev libtool zlib1g-dev libglib2.0-dev \
			     make pkg-config gawk subversion expect git libxml2-utils syslinux \
			     xsltproc yasm iasl lynx unzip tftpd-hpa isc-dhcp-server
#
# ================================================================

# ================================================================
# Compile task for toolchain host
tasks:
	for task in cond_42 cond_mod hey idle linpack namaste pi tumatmul ; do \
		$(MAKE) -C $(JENKINS_GENODE_BUILD_DIR) $$task ; \
		cp $(JENKINS_GENODE_BUILD_DIR)/$$task/$$task ../bin/ ; \
	done
