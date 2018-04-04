#############################################################################
# LibNbiot: Makefile for building Telekom nbiot libraries
#
# Copyright (c) 2018, Edgar Hindemith, Yassine Amraue, Thorsten
# Krautscheid, Kolja Vornholt, T-Systems International GmbH
# contact: libnbiot@t-systems.com, opensource@telekom.de
#
# This file is distributed under the conditions of the Apache License,
# Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# For details see the file LICENSE at the toplevel.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#############################################################################

# Define any target platforms here. Only platforms listed here will be build.
# Each platform entry requires the according entries in the Makefiles of the
# subprojects.
# Platforms listed here will override settings in the subprojects. I.e. all
# platforms can be activated in the subprojects but which are actually build
# is controlled here.
#
# Currently these platforms are supported.
# export PLATFORMS := default x86 x86-debug x86-shared x86-debug-shared x86_64 x86_64-debug x86_64-shared x86_64-shared-debug arm-cortex-m3 arm-cortex-m3-debug
export PLATFORMS := default


# Internal variables
LIBDIR   := lib
INCDIR   := include


# Name of lib directories
APPLIB   := libNbiot
CORELIB  := libNbiotCore
EXTERNAL := external


# Targets
.PHONY: $(EXTERNAL) $(CORELIB) $(APPLIB) directories


.NOTPARALLEL: $(EXTERNAL) $(CORELIB) $(APPLIB)


all: $(EXTERNAL) $(CORELIB) $(APPLIB)


$(APPLIB): $(CORELIB)
	@echo "building: $@"
	$(MAKE) -j -e -C $@ CORE=../$(CORELIB) \
          EXT=../$(EXTERNAL)
	@echo "copy build results"
	cp -r $@/lib/* $(LIBDIR)/.
	cp -r $@/include/* $(INCDIR)/.


$(CORELIB): $(EXTERNAL)
	@echo "building: $@"
	$(MAKE) -j -e -C $@
	@echo "copy build results"
	cp -r $@/lib/* $(LIBDIR)/.
	cp -r $@/include/* $(INCDIR)/.


$(EXTERNAL): directories
	@echo "building: $@"
	$(MAKE) -j -e -C $@ CORE=../$(CORELIB)
	@echo "copy build results"
	cp -rf $@/lib/* $(LIBDIR)/.
	cp -rf $@/include/* $(INCDIR)/.


directories:
	@echo "creating directories for headers and libs"
	[ -d $(INCDIR) ] || mkdir -p $(INCDIR)
	[ -d $(LIBDIR) ] || mkdir -p $(LIBDIR)


clean:
	$(MAKE) clean -C $(EXTERNAL)
	$(MAKE) clean -C $(CORELIB)
	$(MAKE) clean -C $(APPLIB)
	rm -rf $(LIBDIR) $(INCDIR)