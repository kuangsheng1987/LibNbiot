# LibNbiot - Cloud of Things by NB-IoT

The repository contains the source code for the LibNbiot, which allows to access the
**Telekom Cloud of Things** with **NB-IoT** radio modules.

## Building from command line

The library relieas on [GNU Make](https://www.gnu.org/software/make/) as build system. After downloading it can
be build by navigating into the toplevel directory and executing

    make

This will envoke make in all subdirectories. Furthermore, the directories `lib` and `include` are created
and the build results are copied into them. As the the build system supports multiple cross platform
builds with a single invocation, the `lib` directory contains subdirectories which indicate the target
platform.

To cleanup up all build results perform:

    make clean

The subdirectories contain dedicated makefiles which can be invoked individually. However, there are
some cross dependencies which have to be met: `libNbiotCore` depends on `external` while `libNbiot` depends
on both.

### Cross platform builds

The build system has been setup to support cross compilation for multiple platforms. In general
the build can be executed for several platforms at once, given that the given platform dependencies
are already installed on the build system.

Currently the following platforms are supported:

* **default** (build setting are mostly taken from the build system, static library, debug settings enabled)
* **x86** (32-bit, static library, optimized for size)
* **x86-debug** (32-bit, static library, debug settings enabled)
* **x86-shared** (32-bit, shared library, optimized for size)
* **x86-debug-shared** (32-bit, shared library, debug settings enabled)
* **x86_64** (64-bit, static library, optimized for size)
* **x86_64-debug** (64-bit, static library, debug settings enabled)
* **x86_64-shared** (64-bit, shared library, optimized for size)
* **x86_64-shared-debug** (64-bit, shared library, debug settings enabled)
* **arm-cortex-m3** (ARM Cortex M3 bare metal, static library, optimized for size)
* **arm-cortex-m3-debug** (ARM Cortex M3 bare metal, static library, debug settings enabled)

By default the only target platform enabled is **default**. To enable another/additional one, just open
the makefile and add it to the PLATFORMS variable. For example the variable should look like this

    export PLATFORMS := arm-cortex-m3 arm-cortex-m3-debug

if debug and release version are to be build for the ARM Cortx M3 architecture.

**Note:** The platform settings are propagated from the toplevel makefile to the makefiles in the
subdirectories, overruling any platforms configured there. While calling make in the subdirectories
will build the sources there with the platform settings in this subdirectorie's makefile, calling the
the toplevel makefile configures platforms for all subdirectories.

#### Adding further architectures

Obviously, each cross platform build requires certain compiler/linker settings unique to the target
platform. These need to be configured in all makefiles which actually compile the source code. For this
reason, the makefiles contain sections where these platform specific settings are configured. For example,
the section for building the debug version of the library for the ARM Cortex M3 architecture looks like this:

    ifeq ($(ARCH),arm-cortex-m3-debug)
    CXX       := arm-none-eabi-gcc
    CXXFLAGS  := -mcpu=cortex-m3 -mthumb -Wa,-alh=nbiot_time.lst \
      -g -Wall -ffunction-sections -D DEBUG -g -O0 -ffat-lto-objects -std=c++0x -ggdb
    endif

It sets the compiler `(CXX)` and compiler flags `(CXXFLAGS)` to use for the build. These variables have to
be set to values which suit the target enviroment. An important detail is the initial if-statement, where
make checks the architecture. In this statement, `arm-cortex-m3-debug` defines the name of the target
environment. If the very same name is added to the PLATFORMS entry at the beginning of the makefile, the
target is activated and the sources are build for this platform as well.

The same statemant has to be added to all makefiles which actually compile and link code. This is necessary
to ensure that the compiled code of the subdirectories is compatible with each other. This means the makefiles
found in

* libNbiot
* libNbiotCore
* external

have to include the same if-statement.

#### Troubleshooting:

**x86 build fails on x86_64 platform**

When compiling for 32-bit platforms on 64-bit platform you may encounter this error (or a similar one):  

    /usr/include/c++/6/cstdlib:41:28: fatal error: bits/c++config.h: No such file or directory`

The reason for this is usually, that the GCC multilib feature is enabled, which indicates that the
32-bit version of the libc is not installed. To fix this error install:

* CentOS/RHEL 5.x:  
`yum -y install glibc-devel.i386 libstdc++-devel.i386`  
* CentOS/RHEL 6.x:  
`yum -y install glibc-devel.i686 glibc-devel ibstdc++-devel.i686`  
* Debian/Ubuntu:  
`sudo apt-get install g++-multilib libc6-dev-i386`  
* SLES/OpenSUSE:  
`zypper in glibc-devel-32bit`  


### License

Copyright (C) 2018, Edgar Hindemith, Yassine Amraue, Thorsten Krautscheid, Kolja Vornholt, T-Systems International GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied.
See the License for the specific language governing permissions and
limitations under the License.
