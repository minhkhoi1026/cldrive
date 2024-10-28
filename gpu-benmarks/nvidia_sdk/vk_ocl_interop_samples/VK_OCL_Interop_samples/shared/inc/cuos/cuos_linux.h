/* 
 * Copyright 2006-2014 by NVIDIA Corporation.  All rights reserved.  All
 * information contained herein is proprietary and confidential to NVIDIA
 * Corporation.  Any use, reproduction, or disclosure without the written
 * permission of NVIDIA Corporation is prohibited.
 */

#ifndef _CUOS_H_
#error "Use cuos.h, not cuos_*.h"
#endif

#ifndef _CUOS_LINUX_H_
#define _CUOS_LINUX_H_

#include "cuos_common_posix.h"

#ifndef _GNU_SOURCE
#define _GNU_SOURCE // Needed for struct ucred and SCM_CREDENTIALS
#define __USE_GNU 1 // Workaround if the features.h has already been included
#endif

#include <semaphore.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

typedef sem_t cuosSem;

typedef struct cuostimer {
    struct timespec t;
} cuosTimer;

typedef struct cuosEvent {
    unsigned createdByCuos : 1;
    unsigned ipcEvent    : 1;
    // Indicates the event gets signaled in poll() only once when the event occurs.
    // To make sure it's handled, cuosEventWaitMultiple() saves the signal in
    // signalCount if it's not returned immediately.
    unsigned isEdgeTriggered: 1;
    // Indicated that a signaled event should not reset automatically after waiting
    unsigned isManualReset: 1;
    unsigned needsWarForBug1938043: 1;
    int readFd;
    int writeFd; // Unused unless this is a created pipe
    unsigned int signalCount;
} cuosEvent;

// Specify the reader or writer mode for IPC event.
typedef enum {
    CUOS_EVENT_SIGNAL_MODE          = 1, // Event is opened in blocking write-only mode.
    CUOS_EVENT_WAIT_MODE            = 2, // Event is opened in blocking read-only mode.
    CUOS_EVENT_WAIT_MODE_NONBLOCK   = 3  // Event is opened in non-blocking read-only mode.
} cuosEventMode_t;

typedef struct {
    int fd;
} CUOSserverSocket;

typedef struct {
    int fd;
} CUOSsocket;

#define CUOS_MSG_IOVEC_SIZE 32
#define CUOS_MSG_FDNUM_SIZE 32

typedef struct {
    union {
        size_t sent;
        struct {
            size_t received;
            unsigned char truncated : 1;
            unsigned char control_truncated : 1;
        };
    };
    size_t iovlen;
    struct iovec iov[CUOS_MSG_IOVEC_SIZE];
    size_t fdnum;
    int fd[CUOS_MSG_FDNUM_SIZE];
#ifndef __QNX__
    unsigned char credset : 1;
    struct ucred cred;
#endif
} CUOSsocketMsg;

/* Return the number of bytes needed for a mask of the processors in the system */
size_t cuosProcessorMaskSize(void);

// Those functions should be properly abstracted - for example use HANDLE instead of int.
// For now keep them OS-specific.
int cuosSocketRecvFd(CUOSsocket *socket, int *recvFd);
int cuosSocketSendFd(CUOSsocket *socket, int sendFd);
int cuosSocketRecvCred(CUOSsocket *socket, CUOSPid *pid, CUOSUid *uid, CUOSGid *gid);
int cuosSocketSendCred(CUOSsocket *socket, CUOSPid *pid, CUOSUid *uid, CUOSGid *gid);

static inline int cuosSocketMsgAddSizedIO(CUOSsocketMsg *msg, void *data, size_t size)
{
    if (msg->iovlen >= CUOS_MSG_IOVEC_SIZE) {
        return CUOS_ERROR;
    }

    msg->iov[msg->iovlen].iov_base = data;
    msg->iov[msg->iovlen].iov_len = size;
    msg->iovlen++;
    return CUOS_SUCCESS;
}

int cuosLinuxKernelVersion(int *kernelVersion, int *majorRevision, int *minorRevision);

// Returns CUOS_SUCCESS on succerss or CUOS_FAILURE on error. Note that a
// failure can occur if the namespace is not supported by the OS.
int cuosGetLinuxNamespaceInode(const char *ns, const CUOSPid *pid, long long *inodeRet);

/**
 *
 * OpenGL types
 *
 */

// Name of library to cuosLoadLibrary to load GL
#if defined(__ANDROID__) || defined(__QNX__) || defined(__APPLE__)
#define CUOS_EGL_LIBRARY_NAME           "libEGL.so"
#else
#define CUOS_EGL_LIBRARY_NAME           "libEGL.so.1"
#endif
#define CUOS_GL_LIBRARY_NAME            "libGL.so.1"
#define CUOS_GL_VENDOR_LIBRARY_NAME     "libGLX_nvidia.so.0"

// Name to pass to cuosGetProcAddress for GL's get proc address
#define CUOS_EGL_GET_PROC_ADDRESS_FUNC_NAME     "eglGetProcAddress"
#define CUOS_GL_GET_PROC_ADDRESS_FUNC_NAME      "glXGetProcAddressARB"

// Name to pass to cuosGetProcAddress for GL's get current context
#define CUOS_EGL_GET_CURRENT_CONTEXT_FUNC_NAME   "eglGetCurrentContext"
#define CUOS_GL_GET_CURRENT_CONTEXT_FUNC_NAME    "glXGetCurrentContext"

// Type to cast the result to
typedef void (*CUOSglProcFn)(void);
typedef CUOSglProcFn (*CUOSglGetProcAddressFn)(const char *);


// Type to cast the result to
typedef void * (*CUOSglGetCurrentContextFn)(void);

#define cuosThreadIdPrintFormat "%lu"
#define cuosThreadIdPrintArguments(tid) tid

#if defined(__cplusplus)
} // namespace or extern "C"
#endif

#endif // _CUOS_LINUX_H_
