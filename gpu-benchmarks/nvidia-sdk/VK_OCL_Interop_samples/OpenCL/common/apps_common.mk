ifeq ($(ENABLE_OPENCL_2_0), 1)
    OPENCL_FORK_DIR := cl_dev
    DEFINES += ENABLE_OPENCL_2_0=1
else
    OPENCL_FORK_DIR := cl_rel
endif

NO_GOLD ?= 1
# Request no dialect option on nvcc command line, otherwise
# some builds fail (bug 200317645).
CXX_STD :=

SUFFIX :=
ifneq ($(ABITYPE),)
    SUFFIX := _$(ABITYPE)
endif

INCLUDES += ../../import/common
INCLUDES  += ../common/oclUtils
INCLUDES  += ../common/shrUtils
LIBDIRS  += ../../import/common/$(ARCH)_$(OS)$(SUFFIX)

INCLUDES += ../../import/$(OPENCL_FORK_DIR)
LIBDIRS  += ../../import/$(OPENCL_FORK_DIR)/$(ARCH)_$(OS)$(SUFFIX)

FILES       +=../common/oclUtils/oclUtils.cpp
FILES       +=../common/shrUtils/shrUtils.cpp
FILES       += ../common/shrUtils/cmd_arg_reader.cpp

NVCC_LDFLAGS    += --dont-use-profile --no-device-link
CUDART_LINK := none
LIBRARIES += OpenCL
ifeq ($(TARGET_ARCH), aarch64)
	LIBRARIES    += m
endif
OPENCL_BUILD := 1
