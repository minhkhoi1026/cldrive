

#ifndef _CUOS_H_
#error "Use cuos.h, not cuos_*.h"
#endif

#ifndef _CUOS_LINUX_H_
#define _CUOS_LINUX_H_

#include "cuos_common_posix.h"

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 
#define __USE_GNU 1 
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
    
    
    
    unsigned isEdgeTriggered: 1;
    
    unsigned isManualReset: 1;
    unsigned needsWarForBug1938043: 1;
    int readFd;
    int writeFd; 
    unsigned int signalCount;
} cuosEvent;


typedef enum {
    CUOS_EVENT_SIGNAL_MODE          = 1, 
    CUOS_EVENT_WAIT_MODE            = 2, 
    CUOS_EVENT_WAIT_MODE_NONBLOCK   = 3  
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


size_t cuosProcessorMaskSize(void);



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



int cuosGetLinuxNamespaceInode(const char *ns, const CUOSPid *pid, long long *inodeRet);




#if defined(__ANDROID__) || defined(__QNX__) || defined(__APPLE__)
#define CUOS_EGL_LIBRARY_NAME           "libEGL.so"
#else
#define CUOS_EGL_LIBRARY_NAME           "libEGL.so.1"
#endif
#define CUOS_GL_LIBRARY_NAME            "libGL.so.1"
#define CUOS_GL_VENDOR_LIBRARY_NAME     "libGLX_nvidia.so.0"


#define CUOS_EGL_GET_PROC_ADDRESS_FUNC_NAME     "eglGetProcAddress"
#define CUOS_GL_GET_PROC_ADDRESS_FUNC_NAME      "glXGetProcAddressARB"


#define CUOS_EGL_GET_CURRENT_CONTEXT_FUNC_NAME   "eglGetCurrentContext"
#define CUOS_GL_GET_CURRENT_CONTEXT_FUNC_NAME    "glXGetCurrentContext"


typedef void (*CUOSglProcFn)(void);
typedef CUOSglProcFn (*CUOSglGetProcAddressFn)(const char *);



typedef void * (*CUOSglGetCurrentContextFn)(void);

#define cuosThreadIdPrintFormat "%lu"
#define cuosThreadIdPrintArguments(tid) tid

#if defined(__cplusplus)
} 
#endif

#endif 
