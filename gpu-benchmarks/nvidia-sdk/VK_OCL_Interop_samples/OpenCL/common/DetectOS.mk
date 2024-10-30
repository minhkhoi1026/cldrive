ifndef OS

 OS   := $(shell uname)
 
 ifndef HOST_ARCH 
  HOST_ARCH := $(shell uname -m)
 endif
 ifeq ($(HOST_ARCH),armv7l)
  HOST_ARCH := ARMv7
 endif

else

 ifeq ($(OS),Windows_NT)
  OS := win32
 endif

 ifndef HOST_ARCH
  ifeq ($(OS),win32)
   ifeq ($(PROCESSOR_ARCHITECTURE),x86)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
     HOST_ARCH := x86_64
    else
     HOST_ARCH := i686
    endif
   else
    HOST_ARCH := x86_64
   endif
   ifeq ($(HOST_ARCH),x86_64)
    ifdef USEVC7
     $(error USEVC7 not possible for win64)
    endif
   endif
  endif
 endif
endif

ifndef OS_VARIANT
  OS_VARIANT := Native
endif

ifndef TARGET_ARCH
 TARGET_ARCH := $(HOST_ARCH)
endif

TARGET_ARCH_SIZE := $(if $(filter $(TARGET_ARCH),aarch64 x86_64 ppc64le x86_64),64,32)

ARCH_SIZE:=$(TARGET_ARCH_SIZE)

TARGET_ARCH_IS_ARM := $(if $(filter $(TARGET_ARCH),ARMv7 aarch64),1,0)

TARGET_ARCH_SUPPORTS_EGL := $(if $(filter $(TARGET_ARCH),ARMv7 aarch64 x86_64),1,0)

#
# There are a LOT of files (e.g. almost every makefile in apps/...)
# using $(ARCH) which need to be sifted through.  Until they are all exorcized
# just make it so that ARCH==TARGET_ARCH.
# This means you can set TARGET_ARCH yet all the old makefiles
# should still work.
#
ARCH:=$(TARGET_ARCH)

export ARCH
export TARGET_ARCH
export HOST_ARCH
export TARGET_ARCH_SIZE

