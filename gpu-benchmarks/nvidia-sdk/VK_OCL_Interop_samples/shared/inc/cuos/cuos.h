



#ifndef _CUOS_H_
#define _CUOS_H_

#ifdef __GNUC__
  #define GCC_PRAGMA(x) GCC_PRAGMA_DO(GCC x)
  #define GCC_PRAGMA_DO(x) _Pragma(#x)
  
  
  #if ((__GNUC__ * 100) + __GNUC_MINOR__) >= 406
    #define GCC_DIAG_PRAGMA(x) GCC_PRAGMA(diagnostic x)
  #else
    #define GCC_DIAG_PRAGMA(x)
  #endif
#else
  #define GCC_PRAGMA(x)
  #define GCC_DIAG_PRAGMA(x)
#endif
#ifdef __clang__
  #define CLANG_PRAGMA(x) CLANG_PRAGMA_DO(clang x)
  #define CLANG_PRAGMA_DO(x) _Pragma(#x)
  #define CLANG_DIAG_PRAGMA(x) CLANG_PRAGMA(diagnostic x)
#else
  #define CLANG_PRAGMA(x)
  #define CLANG_DIAG_PRAGMA(x)
#endif


#ifndef __has_builtin
#define __has_builtin(intrinsic) 0
#endif

#ifndef __has_feature
#define __has_feature(feature) 0
#endif




#define CUOS_ROUND_UP(n, multiple) \
    ( ((n) + ((multiple) - 1)) - (((n) + ((multiple) - 1)) % (multiple)) )


#define CUOS_ROUND_DOWN(n, multiple) \
    ( (n) - ((n) % (multiple)) )

#define CUOS_MIN(a, b) ((a) < (b) ? (a) : (b))
#define CUOS_MAX(a, b) (((a) > (b)) ? (a) : (b))

#include <stdio.h>
#include <string.h>

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

typedef struct CUOSthread_st CUOSthread;


enum { CUOS_SUCCESS =  0,
       CUOS_ERROR   = -1,
       CUOS_TIMEOUT = -2,
       CUOS_EOF = -3 };


typedef enum {
      CUOS_SEEK_SET = 0,
      CUOS_SEEK_CUR = 1,
      CUOS_SEEK_END = 3 } cuosSeekEnum;


typedef struct cuosShmInfo_st
{
    void *hMapFile;             
    void *pViewOfFile;          
    size_t size;                
} cuosShmInfo;

#define CUOS_SHM_EX_TEMPLATE_MAX 40
#define CUOS_SHM_EX_TEMPLATE "/" MODULE_NAME_LOWERCASE ".shm.%x.%x.%llx"

typedef struct cuosShmInfoEx_st cuosShmInfoEx;

typedef enum CUOSshmCloseExFlags_enum
{
    CUOS_SHM_CLOSE_EX_INVALID              = 0,
    
    CUOS_SHM_CLOSE_EX_DECOMMIT             = 1,
    
    CUOS_SHM_CLOSE_EX_RELEASE              = 2,
} CUOSshmCloseExFlags;

typedef struct cuosShmKey_st
{
    unsigned long pid;
    unsigned long long serial;
} cuosShmKey;

typedef struct CUOSpipe_st CUOSpipe;

#if defined(__cplusplus)
} 
#endif

#if defined(NV_MODS)

#include "cuos_mods.h"
#else


#if defined(_WIN32)
#include "cuos_win32.h"
#elif defined(__APPLE__)
#include "cuos_darwin.h"
#elif defined(__HOS__)
#include "cuos_common_nvos.h"
#else    
#include "cuos_linux.h"
#endif 
#include "cuos_io.h"

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

typedef struct cuosBarrier_st {
    CUOSCriticalSection mutex;
    cuosCV cv;
    unsigned int limit;
    unsigned int count;
    volatile unsigned long long signalSeq;
} cuosBarrier;

typedef struct cuosLocalTime_s {
    unsigned int year;
    unsigned int month;         
    unsigned int dayOfMonth;    
    unsigned int dayOfWeek;     
    unsigned int hour;          
    unsigned int min;           
    unsigned int sec;           
    unsigned int msec;          
} cuosLocalTime;




#define cuosMemset memset
#define cuosMemcpy memcpy


void cuosInit(void);

void cuosCPUID(int a[4], int ax);

void cuosThreadYield(void);




void cuosThreadYieldHeavy(void);

void cuosSleep(unsigned int msec);
unsigned long long cuosTotalPhysicalMemory(void);
unsigned long long cuosFreePhysicalMemory(void);
unsigned long long cuosTotalSwapMemory(void);
unsigned long long cuosFreeSwapMemory(void);
unsigned int cuosGetProcCoreCount(void);


int cuosKernelIs64Bit(void);

CUOSTLSEntry cuosTlsAlloc(void (*f)(void*));
void cuosTlsFree(CUOSTLSEntry);
void *cuosTlsGetValue(CUOSTLSEntry);
int cuosTlsSetValue(CUOSTLSEntry, void *v);

void cuosInitializeCriticalSection(CUOSCriticalSection *x);
void cuosInitializeCriticalSectionShared(CUOSCriticalSection *x);
void cuosDeleteCriticalSection(CUOSCriticalSection *x);
void cuosEnterCriticalSection(CUOSCriticalSection *x);
int cuosTryEnterCriticalSection(CUOSCriticalSection *x);
void cuosLeaveCriticalSection(CUOSCriticalSection *x);









void cuosInitRWLock(CUOSRWLock *);
void cuosAcquireReaderLock(CUOSRWLock *);
void cuosAcquireWriterLock(CUOSRWLock *);
int cuosTryAcquireReaderLock(CUOSRWLock *);
int cuosTryAcquireWriterLock(CUOSRWLock *);
void cuosReleaseReaderLock(CUOSRWLock *);
void cuosReleaseWriterLock(CUOSRWLock *);
void cuosDestroyRWLock(CUOSRWLock *);







int  cuosInitRWLockEx(CUOSRWLock *, void *, size_t);
void cuosDestroyRWLockEx(CUOSRWLock *);

CUOSPid cuosProcessId(void);
int cuosProcessHasExited(CUOSPid pid);

#if !defined(CUOS_ATOMICS_DEFINED)
#error No atomic intrinsics are defined! __GNUC__ __GNUC_MINOR__
#endif



unsigned int        cuosInterlockedCompareExchange(volatile unsigned int *v,
                                                   unsigned int exchange,
                                                   unsigned int compare);
unsigned long long  cuosInterlockedCompareExchange64(volatile unsigned long long *v,
                                                     unsigned long long exchange,
                                                     unsigned long long compare);
void                *cuosInterlockedCompareExchangePointer(void * volatile *v, void *exchange, void *compare);
unsigned int        cuosInterlockedExchange(volatile unsigned int *v, unsigned int exchange);
unsigned int        cuosInterlockedAnd(volatile unsigned int *v, unsigned int mask);
unsigned long long  cuosInterlockedAnd64(volatile unsigned  long long *v, unsigned  long long mask);
unsigned int        cuosInterlockedOr(volatile unsigned int *v, unsigned int mask);
unsigned long long  cuosInterlockedOr64(volatile unsigned long long *v, unsigned  long long mask);

unsigned int        cuosInterlockedIncrement(volatile unsigned int *v);
unsigned long long  cuosInterlockedIncrement64(volatile unsigned long long *v);
unsigned int        cuosInterlockedDecrement(volatile unsigned int *v);
unsigned long long  cuosInterlockedDecrement64(volatile unsigned long long *v);

GCC_DIAG_PRAGMA(push)
CLANG_DIAG_PRAGMA(push)


GCC_DIAG_PRAGMA(ignored "-Wcast-qual")
CLANG_DIAG_PRAGMA(ignored "-Wcast-qual")
static unsigned int cuosInterlockedRead(volatile const unsigned int *ptr)
{
    
    return cuosInterlockedCompareExchange((volatile unsigned int *)ptr, 0, 0);
}

static unsigned long long cuosInterlockedRead64(volatile const unsigned long long *ptr)
{
    
    return cuosInterlockedCompareExchange64((volatile unsigned long long *)ptr, 0, 0);
}
CLANG_DIAG_PRAGMA(pop)
GCC_DIAG_PRAGMA(pop)

static void* cuosInterlockedReadPointer(void * volatile *ptr)
{
    #if defined(__LP64__) || defined(_WIN64)
        return (void *)(size_t)cuosInterlockedRead64((volatile const unsigned long long *)ptr);
    #else
        return (void *)(size_t)cuosInterlockedRead((volatile const unsigned int *)ptr);
    #endif
}

static void* cuosInterlockedExchangePointer(void * volatile *ptr, void *exchange)
{
    void *old;
    do {
        old = *ptr;
    } while (cuosInterlockedCompareExchangePointer(ptr, exchange, old) != old);
    return old;
}

static unsigned long long cuosInterlockedExchange64(volatile unsigned long long *ptr, unsigned long long exchange)
{
    unsigned long long old;
    do {
        old = *ptr;
    } while (cuosInterlockedCompareExchange64(ptr, exchange, old) != old);
    return old;
}






int cuosOnce(cuosOnceControl *onceControl, void (*initRoutine)(void));

typedef enum CUOSeventCreateFlags_enum
{
    
    CUOS_EVENT_CREATE_DEFAULT         = 0,
    
    
    CUOS_EVENT_CREATE_MANUAL_RESET    = (1 << 0)
} CUOSeventCreateFlags;

int cuosEventCreate(cuosEvent *event);

int cuosGpuEventsCreate(int fd, int numEvents, unsigned int *eventTypes, cuosEvent *events);


int cuosEventPoll(cuosEvent *errEvent, unsigned int *isSignaled);


int cuosEventCreateWithFlags(cuosEvent *event, unsigned int flags);

#define CUOS_INFINITE_TIMEOUT   ((unsigned int)~0)



int cuosEventWaitMultiple(cuosEvent **events,
                  int           numEvents,
                  int           *returnedEvents,
                  unsigned int  maxReturnedEvents,
                  unsigned int  timeoutMs);


static int cuosEventWait(cuosEvent **events, int numEvents, int *signaledIndex, unsigned int timeoutMs)
{
    int signaledEvent;

    if (!signaledIndex) {
        signaledIndex = &signaledEvent;
    }

    return cuosEventWaitMultiple(events, numEvents, signaledIndex, 1, timeoutMs);
}

int cuosEventSignal(cuosEvent *event);


int cuosEventClear(cuosEvent *event);


void *cuosEventGetOsPtr(cuosEvent *event, unsigned int hClient, unsigned int hDevice);


int cuosEventIsSafeToSignal(cuosEvent *event);


int cuosIpcMakeName(char *generated_name, const char *base_name, size_t bufsize);


int cuosIpcCreate(char *name);


int cuosIpcDestroy(char *name);


int cuosEventIpcCreate(cuosEvent *event, char *ipcobj_name, cuosEventMode_t mode);


int cuosEventIpcCreateWithFlags(cuosEvent *event, char *ipcobj_name, cuosEventMode_t mode, unsigned int flags);


int cuosEventDestroy(cuosEvent *event);




int cuosReadLockFile(FILE *stream, unsigned int waitForMs);
int cuosWriteLockFile(FILE *stream, unsigned int waitForMs);


int cuosLockFile(FILE *stream, unsigned int waitForMs);


int cuosUnlockFile(FILE *stream);


long long cuosGetFileSize(const char *path);


#define CUOS_OPEN_READ    0x1


#define CUOS_OPEN_WRITE   0x2


#define CUOS_OPEN_CREATE  0x4


#define CUOS_OPEN_APPEND  0x8



int cuosFopen(const char *path, unsigned long flags, cuosFileHandle *stream);


void cuosFclose(cuosFileHandle stream);


int
cuosFwrite(cuosFileHandle stream, const void *ptr, size_t size);


int
cuosFread(cuosFileHandle stream, void *ptr, size_t size, size_t *bytes);


int
cuosFgetc(cuosFileHandle stream, char *c);


int
cuosFseek(cuosFileHandle stream, unsigned long long offset, cuosSeekEnum whence);


int
cuosFtell(cuosFileHandle stream, unsigned long long *position);


int
cuosFflush_internal(cuosFileHandle stream);


int cuosMkdir(const char* path);


int cuosRmdir(const char *path);


int cuosRm(const char *path);


int cuosRmdirRecursive(const char *path);


void cuosGetUserDataNVPath(char *buffer, size_t bufferSize);


int cuosGetcwd(char *buffer, size_t bufferSize);

CUOSLibrary cuosLoadLibrary(const char *name);
CUOSLibrary cuosLoadLibraryUnsafe(const char *name);
int cuosFreeLibrary(CUOSLibrary lib);
void (*cuosGetProcAddress(CUOSLibrary lib, const char *name))(void);

void cuosResetTimer(cuosTimer *timer);

float cuosGetTimer(cuosTimer *timer);


unsigned long long cuosGetCpuTime (void);

void cuosGetLocalTime(cuosLocalTime *localTime);

int cuosSetEnv(const char* env, const char *val);











int cuosGetEnv(const char* env, char *val, size_t size);


unsigned int cuosGetPageSize(void);

typedef enum CUOSvirtualAllocFlags_enum
{
    CUOS_VIRTUAL_ALLOC_INVALID             = 0,
    
    CUOS_VIRTUAL_ALLOC_RESERVE             = 1,
    
    CUOS_VIRTUAL_ALLOC_COMMIT              = 2,
    
    CUOS_VIRTUAL_ALLOC_RESERVE_AND_COMMIT  = 3,
} CUOSvirtualAllocFlags;
typedef enum CUOSvirtualAccessFlags_enum
{
    
    CUOS_VIRTUAL_ACCESS_DEFAULT      = 0,
    
    CUOS_VIRTUAL_ACCESS_UNCACHED     = 1,
    
    CUOS_VIRTUAL_ACCESS_WRITECOMBINE = 2,
    
    CUOS_VIRTUAL_ACCESS_NONE         = 3,
} CUOSvirtualAccessFlags;
void *cuosVirtualAlloc(void *addr, size_t size, unsigned int allocFlags, unsigned int accessFlags);





void *cuosVirtualAllocInRange(void *hintAddr, size_t size, unsigned int allocFlags, unsigned int accessFlags,
                              void* base, void *limit, size_t align);

void *cuosVirtualReserveInRange(size_t size, void *base, void* limit, size_t align);




void *cuosVirtualFindFreeVaInRange(size_t size, void *base, void *limit, size_t align);

typedef enum CUOSvirtualFreeFlags_enum
{
    CUOS_VIRTUAL_FREE_INVALID              = 0,
    
    CUOS_VIRTUAL_FREE_DECOMMIT             = 1,
    
    CUOS_VIRTUAL_FREE_RELEASE              = 2,
} CUOSvirtualFreeFlags;
void  cuosVirtualFree(void *addr, size_t size, unsigned int freeFlags);

typedef enum CUOSvirtualProtectFlags_enum
{
    
    CUOS_VIRTUAL_PROTECT_NOACCESS      = 0,
    
    CUOS_VIRTUAL_PROTECT_READ          = 1,
    
    CUOS_VIRTUAL_PROTECT_READWRITE     = 2,
} CUOSvirtualProtectFlags;
int cuosVirtualProtect(void *addr, size_t size, unsigned int protectFlags);

typedef enum CUOSmadviseFlags_enum
{
    CUOS_MADVISE_DONTFORK = 0,
    CUOS_MADVISE_DOFORK   = 1,
} CUOSmadviseFlags;
int cuosMadvise(void *addr, size_t length, unsigned int advice);


void* cuosShmCreate(const char *name, const size_t size);
void* cuosShmOpen(const char *name);
void cuosShmDestroy(void *hMapFile);
void* cuosShmMap(void *hMapFile, const size_t size);
void cuosShmUnmap(void *pMapMemory);
void* cuosShmBaseAddress(const cuosShmInfo *shmInfo);
size_t cuosShmSize(const cuosShmInfo *shmInfo);


int cuosShmCreateEx(void *addr, cuosShmKey *key, size_t size, cuosShmInfoEx **shmInfoEx);


int cuosShmCreateNamedEx(void *addr, const char *key, size_t size, cuosShmInfoEx **shmInfoEx);


int cuosShmOpenEx(void *addr, cuosShmKey *key, size_t size, cuosShmInfoEx **shmInfoEx);


int cuosShmOpenNamedEx(void *addr, const char *key, size_t size, cuosShmInfoEx **shmInfoEx);


void cuosShmCloseEx(cuosShmInfoEx *shmInfoEx, unsigned int shmCloseExFlags, unsigned int unlink);


int cuosShmIsOwner(cuosShmInfoEx *shmInfoEx, int *isOwner);


int cuosThreadCreate(
    CUOSthread **thread,
    int (*startFunc)(void*),
    void *userData);

int cuosThreadCreateWithName(
    CUOSthread **thread,
    int (*startFunc)(void*),
    void *userData,
    const char *name);


void cuosThreadJoin(CUOSthread *thread, int *retCode);


void cuosThreadDetach(CUOSthread *thread);


CUOSthreadId cuosGetCurrentThreadId(void);


int cuosThreadIsCurrent(CUOSthread *thread);


int cuosThreadIdEqual(CUOSthreadId tid1, CUOSthreadId tid2);


int cuosHasThreadExited(CUOSthread *thread);



void cuosGetThreadAffinity(CUOSthread *thread, size_t *mask);



void cuosSetThreadAffinity(CUOSthread *thread, const size_t *mask);


#define cuosProcessorMaskWordBits() (8 * sizeof(size_t))


#define cuosProcessorMaskZero(mask) memset((mask), '\0', cuosProcessorMaskSize())


#define cuosProcessorMaskSet(mask, proc) \
do { \
    size_t _proc = (proc); \
    (mask)[_proc / cuosProcessorMaskWordBits()] |= (size_t)1 << (_proc % cuosProcessorMaskWordBits()); \
} while (0)


#define cuosProcessorMaskClear(mask, proc) \
do { \
    size_t _proc = (proc); \
    (mask)[_proc / cuosProcessorMaskWordBits()] &= ~((size_t)1 << (_proc % cuosProcessorMaskWordBits())); \
} while (0)


#define cuosProcessorMaskEqual(mask1, mask2) (memcmp((mask1), (mask2), cuosProcessorMaskSize()) == 0)


unsigned int cuosGetProcessorCount(void);


unsigned int cuosGetCurrentProcessor(void);


unsigned long cuosNumaGetNumPossibleNodes(void);



const unsigned long * cuosNumaGetAllowedNodeMask(void);


unsigned long cuosNumaGetNodeIdForProcessor(unsigned int processor);





int cuosNumaGetThreadMemPolicy(int *opaqueMode, unsigned long *nodeMask);





int cuosNumaSetThreadMemPolicy(int opaqueMode, const unsigned long *nodeMask);




int cuosNumaMovePages(unsigned long count, void **pages, const int *nodes, int *status);


int cuosSemaphoreCreate(cuosSem *sem, int value);


int cuosSemaphoreDestroy(cuosSem *sem);


int cuosSemaphoreWait(cuosSem *sem, unsigned int timeoutMs);


int cuosSemaphoreSignal(cuosSem *sem);







int cuosCondCreate(cuosCV *cv);
int cuosCondCreateShared(cuosCV *cv);
int cuosCondWait(cuosCV *cv, CUOSCriticalSection *mutex, unsigned int timeoutMs);
int cuosCondSignal(cuosCV *cv);
int cuosCondBroadcast(cuosCV *cv);
int cuosCondDestroy(cuosCV *cv);





int cuosBarrierCreate(cuosBarrier *barrier, unsigned int limit);
int cuosBarrierWait(cuosBarrier *barrier);
int cuosBarrierDestroy(cuosBarrier *barrier);





int cuosSocketOpenAsServer(const void *name, size_t length, CUOSserverSocket *newSocket);
int cuosSocketAcceptClient(CUOSserverSocket *listeningSocket, CUOSsocket *connectionSocket);
void cuosServerSocketGetDataArrivedEvent(CUOSserverSocket *socket, cuosEvent *event);
void cuosServerSocketClose(CUOSserverSocket *socket);
int cuosSocketOpenAsClient(const void *name, const size_t length, CUOSsocket *newSocket);
int cuosSocketCreateConnectedPair(CUOSsocket *socket1, CUOSsocket *socket2);
int cuosSocketSend(CUOSsocket *socket, CUOSsocketMsg *msg);
int cuosSocketRecv(CUOSsocket *socket, CUOSsocketMsg *msg);
int cuosSocketRead(CUOSsocket *socket, void *data, size_t size);
int cuosSocketWrite(CUOSsocket *socket, const void *data, size_t size);
void cuosSocketClose(CUOSsocket *socket);
void cuosSocketGetDataArrivedEvent(CUOSsocket *socket, cuosEvent *event);

int cuosSocketMsgAddSizedIO(CUOSsocketMsg *msg, void *data, size_t size);
#ifndef __cplusplus
#define cuosSocketMsgAddIO(msg, data) cuosSocketMsgAddSizedIO(msg, (void *)data, sizeof(*data))
#else
#if !defined(CUOS_NAMESPACE)
}
namespace {
#endif
template<class T> struct remove_const          { typedef T type; };
template<class T> struct remove_const<const T> { typedef T type; };

template<typename T>
int cuosSocketMsgAddIO(CUOSsocketMsg *msg, T *data)
{
    return cuosSocketMsgAddSizedIO(msg,
                                   const_cast<typename remove_const<T>::type *>(data),
                                   sizeof(T));
}
#if !defined(CUOS_NAMESPACE)
}
extern "C" {
#endif
#endif









int cuosPipeOpenAsServer(const char *serverPipeName, void *accessControl, CUOSpipe *newPipe);


int cuosPipeAcceptClient(CUOSpipe *serverPipe, CUOSpipe *newClientPipe);







int cuosPipeOpenAsClient(const char *serverPipeName, const char *clientPipeName, CUOSpipe *newPipe);


void cuosPipeGetDataArrivedEvent(CUOSpipe *pipe, cuosEvent *event);
int cuosPipeRead(CUOSpipe *pipe, void *data, size_t size);
int cuosPipeWrite(CUOSpipe *pipe, const void *data, size_t size);
FILE *cuosPipeGetReadStream(CUOSpipe *pipe);
FILE *cuosPipeGetWriteStream(CUOSpipe *pipe);
void cuosPipeClose(CUOSpipe *pipe);
int cuosPipeCreatePair(CUOSpipe *pipe1, CUOSpipe *pipe2);

#if defined(__GNUC__)
     #define __formatprintf__(formatString, firstArg) __attribute__((format(printf, formatString, firstArg)))
#else
     #define __formatprintf__(formatString, firstArg)
#endif

char* 
cuosSprintfMalloc(const char * format, ...) __formatprintf__(1, 2);





int cuosGetCurrentProcessExecPath(char **path);



void *cuosMalloc(size_t size);
void cuosFree(void *ptr);
void *cuosCalloc(size_t nmemb, size_t size);
void *cuosRealloc(void *ptr, size_t size);

int cuosMemoryStartTeardown(void);






void cuosMemoryRetain(void);
void cuosMemoryRelease(void);

int cuosGetHostname(char *name, size_t length);

char *cuosStrdup(const char *str);
size_t cuosStrlen(const char *str);


static void
cuosIntersectAndAlignRanges(size_t range1Start, size_t range1End, size_t range2Start, size_t range2End, size_t align, size_t *rangeIntersectionStart, size_t *rangeIntersectionEnd)
{
    *rangeIntersectionStart = CUOS_MAX(range1Start, range2Start);
    *rangeIntersectionEnd = CUOS_MIN(range1End, range2End);

    *rangeIntersectionStart = CUOS_ROUND_UP(*rangeIntersectionStart, align);

    if (*rangeIntersectionStart > *rangeIntersectionEnd) {
        *rangeIntersectionEnd = *rangeIntersectionStart;
    }
}


int cuosSetThreadName(CUOSthread *thread, const char *name);

#ifdef __HOS__
typedef void* (*cuosNNAllocateCallback_t)(size_t size, size_t align, void *userPtr);
typedef void (*cuosNNFreeCallback_t)(void *addr, void *userPtr);
typedef void* (*cuosNNReallocateCallback_t)(void *addr, size_t newSize, void *userPtr);


int cuosSetHosAllocator(cuosNNAllocateCallback_t allocateCb, cuosNNFreeCallback_t freeCb, cuosNNReallocateCallback_t reallocateCb, void *userPtr);
int cuosIsHosAllocatorInitialized(void);
#endif


#if defined(__cplusplus)
} 
#endif

#endif 


#define CUOS_ENV_VAR_LENGTH 1024

#endif 
