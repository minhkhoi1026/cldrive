/*
 * Copyright 2005-2014 by NVIDIA Corporation.  All rights reserved.  All
 * information contained herein is proprietary and confidential to NVIDIA
 * Corporation.  Any use, reproduction, or disclosure without the written
 * permission of NVIDIA Corporation is prohibited.
 */

/******************************************************************************
*
*   Module: cuos.h
*
*   Description:
*       Cross platform abstraction layer for OS routines
*
******************************************************************************/

#ifndef _CUOS_H_
#define _CUOS_H_

#ifdef __GNUC__
  #define GCC_PRAGMA(x) GCC_PRAGMA_DO(GCC x)
  #define GCC_PRAGMA_DO(x) _Pragma(#x)
  // #pragma gcc diagnostic push and pop were added in 4.6 so only enable
  // diagnostic pragmas there even though gcc diagnostic was added in 4.5.
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

// For non-CLANG compilers
#ifndef __has_builtin
#define __has_builtin(intrinsic) 0
#endif

#ifndef __has_feature
#define __has_feature(feature) 0
#endif

// Rounds n up to the nearest multiple of "multiple".
// if n is already a multiple of "multiple", n is returned unchanged.
// works for arbitrary value of "multiple".
#define CUOS_ROUND_UP(n, multiple) \
    ( ((n) + ((multiple) - 1)) - (((n) + ((multiple) - 1)) % (multiple)) )

// Rounds n down to the nearest multiple of "multiple"
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

/* Return codes indicating the status of cuos function calls. These are not yet in standard
 * use across the library, but they should be used whenever possible to start converging
 * towards a standard error reporting system. */
enum { CUOS_SUCCESS =  0,
       CUOS_ERROR   = -1,
       CUOS_TIMEOUT = -2,
       CUOS_EOF = -3 };

/* File seek operation flags */
typedef enum {
      CUOS_SEEK_SET = 0,
      CUOS_SEEK_CUR = 1,
      CUOS_SEEK_END = 3 } cuosSeekEnum;

// struct containing information about IPC shared memory
typedef struct cuosShmInfo_st
{
    void *hMapFile;             // handle of shared memory
    void *pViewOfFile;          // mapped/attached view of file
    size_t size;                // total size of shared memory
} cuosShmInfo;

#define CUOS_SHM_EX_TEMPLATE_MAX 40
#define CUOS_SHM_EX_TEMPLATE "/" MODULE_NAME_LOWERCASE ".shm.%x.%x.%llx"

typedef struct cuosShmInfoEx_st cuosShmInfoEx;

typedef enum CUOSshmCloseExFlags_enum
{
    CUOS_SHM_CLOSE_EX_INVALID              = 0,
    // Decommit already-committed memory
    CUOS_SHM_CLOSE_EX_DECOMMIT             = 1,
    // Free (and decommit if needed) reserved or committed memory
    CUOS_SHM_CLOSE_EX_RELEASE              = 2,
} CUOSshmCloseExFlags;

typedef struct cuosShmKey_st
{
    unsigned long pid;
    unsigned long long serial;
} cuosShmKey;

typedef struct CUOSpipe_st CUOSpipe;

#if defined(__cplusplus)
} // namespace or extern "C"
#endif

#if defined(NV_MODS)
/* MODS is extra special */
#include "cuos_mods.h"
#else

/* Platform specific types and #defines */
#if defined(_WIN32)
#include "cuos_win32.h"
#elif defined(__APPLE__)
#include "cuos_darwin.h"
#elif defined(__HOS__)
#include "cuos_common_nvos.h"
#else    // Linux
#include "cuos_linux.h"
#endif // which OS
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
    unsigned int month;         // 1-12
    unsigned int dayOfMonth;    // 1-31
    unsigned int dayOfWeek;     // 0-6
    unsigned int hour;          // 0-23
    unsigned int min;           // 0-59
    unsigned int sec;           // 0-59
    unsigned int msec;          // 0-999
} cuosLocalTime;



// TODO: we don't use these consistently, we probably could just toss them
#define cuosMemset memset
#define cuosMemcpy memcpy

// cuosIinit() is safe to call multiple times
void cuosInit(void);

void cuosCPUID(int a[4], int ax);

void cuosThreadYield(void);
// a "heavy" thread yield.  calling this in a loop will give ~0 CPU usage
// it is used only when we have buffered up a lot of work for the GPU (e.g,
// we are out of GPFIFO entries or pushbuffer space).
// bug 437087 (F@H CPU usage at 100% of one core)
void cuosThreadYieldHeavy(void);

void cuosSleep(unsigned int msec);
unsigned long long cuosTotalPhysicalMemory(void);
unsigned long long cuosFreePhysicalMemory(void);
unsigned long long cuosTotalSwapMemory(void);
unsigned long long cuosFreeSwapMemory(void);
unsigned int cuosGetProcCoreCount(void);

// Returns -1 on failure, 0 if the kernel is 32-bit, 1 if the kernel is 64-bit
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

// The reader / writer lock implementation isn't available on all
// platforms. On MODS / HOS this will degrade to a mutex. Code using
// the RWLock shouldn't expect readers to be guaranteed to hold the
// lock concurrently.
//
// In the future we may implement a RWLock in the driver directly if
// needed.
//
void cuosInitRWLock(CUOSRWLock *);
void cuosAcquireReaderLock(CUOSRWLock *);
void cuosAcquireWriterLock(CUOSRWLock *);
int cuosTryAcquireReaderLock(CUOSRWLock *);
int cuosTryAcquireWriterLock(CUOSRWLock *);
void cuosReleaseReaderLock(CUOSRWLock *);
void cuosReleaseWriterLock(CUOSRWLock *);
void cuosDestroyRWLock(CUOSRWLock *);

// This initialize a RWLock with the supplied buffer, instead of
// potentially allocating a new buffer. This is only implemented on
// POSIX where pthread_rwlock_t is not supported by all users.
//
// The size must be larger than the underlying rwlock implementation.
//
int  cuosInitRWLockEx(CUOSRWLock *, void *, size_t);
void cuosDestroyRWLockEx(CUOSRWLock *);

CUOSPid cuosProcessId(void);
int cuosProcessHasExited(CUOSPid pid);

#if !defined(CUOS_ATOMICS_DEFINED)
#error No atomic intrinsics are defined! __GNUC__ __GNUC_MINOR__
#endif

// DEPRECATED: Legacy atomic operations
// All implies sequential consistency
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
// The following return the value after the operation.
unsigned int        cuosInterlockedIncrement(volatile unsigned int *v);
unsigned long long  cuosInterlockedIncrement64(volatile unsigned long long *v);
unsigned int        cuosInterlockedDecrement(volatile unsigned int *v);
unsigned long long  cuosInterlockedDecrement64(volatile unsigned long long *v);

GCC_DIAG_PRAGMA(push)
CLANG_DIAG_PRAGMA(push)
// Ignore the const cast warning as the following two functions do not violate
// it. The CAS is from 0 to 0.
GCC_DIAG_PRAGMA(ignored "-Wcast-qual")
CLANG_DIAG_PRAGMA(ignored "-Wcast-qual")
static unsigned int cuosInterlockedRead(volatile const unsigned int *ptr)
{
    // TODO Improve, we don't really need a CAS here
    return cuosInterlockedCompareExchange((volatile unsigned int *)ptr, 0, 0);
}

static unsigned long long cuosInterlockedRead64(volatile const unsigned long long *ptr)
{
    // TODO Improve, we don't really need a CAS here
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

// Executes the provided callback once by only one thread. All threads which
// call this with the same onceControl parameter will block until the callback
// has been completed. 
//
// onceControl must be initialized to CUOS_ONCE_INIT.
int cuosOnce(cuosOnceControl *onceControl, void (*initRoutine)(void));

typedef enum CUOSeventCreateFlags_enum
{
    // default, same as calling cuosEventCreate directly
    CUOS_EVENT_CREATE_DEFAULT         = 0,
    // create manual-reset event
    // only valid on Linux and Windows
    CUOS_EVENT_CREATE_MANUAL_RESET    = (1 << 0)
} CUOSeventCreateFlags;

int cuosEventCreate(cuosEvent *event);

int cuosGpuEventsCreate(int fd, int numEvents, unsigned int *eventTypes, cuosEvent *events);

/**
 * Poll the event and check if it is signled
 * \return CUOS_SUCCESS if polling succeeds
 * \return CUOS_ERROR if polling fails
 */
int cuosEventPoll(cuosEvent *errEvent, unsigned int *isSignaled);

/**
 * Same as cuosEventCreate, but allows to pass additional flags
 * during event creation.
 * \p flags must be a bitwise-or of CUOSeventCreateFlags
 */
int cuosEventCreateWithFlags(cuosEvent *event, unsigned int flags);

#define CUOS_INFINITE_TIMEOUT   ((unsigned int)~0)

/** Wait on any of the events in the \p events array
 * - This may return at any time, regardless of whether or not an event was
 *   signaled. If no event was signaled (for example the timeout was reached) 0
 *   is returned. Otherwise up to \p maxReturnedEvents signaled events are
 *   returned.
 * - Indices of the returned events are stored in the \p returnedEvents array.
 *   The array needs to be able to store at least \p maxReturnedEvents events.
 * - If the returned events were created by cuosEventCreate then their signal
 *   state is cleared automatically by this function.
 * - If the returned events were created by cuosEventCreateWithFlags with the
 *   CUOS_EVENT_CREATE_MANUAL_RESET flag, then their signal state is not
 *   cleared automatically by this function.
 * - If \p timeoutMs is CUOS_INFINITE_TIMEOUT this may block infinitely.
 *   Otherwise it will return after at most \p timeoutMs. A value of 0 means to
 *   return immediately without blocking.
 * - \p numEvents may be 0. In that case this acts as a sleep for \p timeoutMs.
 * - If numEvents is 0 and \p timeoutMs is CUOS_INFINITE_TIMEOUT, -1 is
 *   returned.
 * - If numEvents is >0 and \p maxReturnedEvents is 0, -1 is returned.
 * \return The number of returned events on success
 * \return -1 on error
 */

int cuosEventWaitMultiple(cuosEvent **events,
                  int           numEvents,
                  int           *returnedEvents,
                  unsigned int  maxReturnedEvents,
                  unsigned int  timeoutMs);

/**
 *  Same as cuosEventWaitMultiple, but returns only for the first signaled event.
 *  \p signaledIndex may be NULL if the index of the signaled event is not
 *  important (e.g. when waiting for a single event only).
 */
static int cuosEventWait(cuosEvent **events, int numEvents, int *signaledIndex, unsigned int timeoutMs)
{
    int signaledEvent;

    if (!signaledIndex) {
        signaledIndex = &signaledEvent;
    }

    return cuosEventWaitMultiple(events, numEvents, signaledIndex, 1, timeoutMs);
}

int cuosEventSignal(cuosEvent *event);

/**
 * Completely clear any signals to cuosEvent. It is not safe to
 * call this function for the same event in parallel with either
 * cuosEventWait or another call to cuosEventClear.
 */
int cuosEventClear(cuosEvent *event);

/**
 * Returns a pointer to the OS-specific object expected by RmAllocEvent
 * Windows: HANDLE hEvent
 * Linux:   &readFd
 * Apple:   (uintptr_t)mach_port_t
 * MODS:    id
 *
 * The two additional arguments are used in MODS to allocate the event
 * for a particular client and device.
 */
void *cuosEventGetOsPtr(cuosEvent *event, unsigned int hClient, unsigned int hDevice);

/** Check if the event is safe to signal.
 *  Returns  0 if not safe to signal
 *          >0 if safe to signal
 *          <0 on error
 */
int cuosEventIsSafeToSignal(cuosEvent *event);

/* Generate a platform suitable name for the ipc object from the specified
 * base name. The size of the output buffer, generated_name, is
 * specified with bufsize.
 */
int cuosIpcMakeName(char *generated_name, const char *base_name, size_t bufsize);

/* Create an ipc object for interprocess synchronization with the specified
 * name. The name of this object should be passed into the cuosEventIpcCreate
 * function in each of the communicating processes. One one of the processes
 * which will create an event from this ipc object must create the ipc object.
 * A process which will not create a cuosEvent should not create the ipc object.
 */
int cuosIpcCreate(char *name);

/* Destroy an ipc object. This must be done after all cuosEvents created on
 * the object have been destroyed and in the same process which created
 * the ipc object.
 */
int cuosIpcDestroy(char *name);

/* Create a cuos event for interprocess synchronization using an ipc object
 * created by cuosIpcCreate. Each process which wishes to synchronize on
 * an ipc object must create its own cuosEvent. The mode argument specifies
 * the only cuosEvent function which can manipulate this process's event,
 * either cuosSignal or cuosEventWait.
 */
int cuosEventIpcCreate(cuosEvent *event, char *ipcobj_name, cuosEventMode_t mode);

/**
 * Same as cuosEventIpcCreate, but allows to pass additional flags
 * during event creation.
 * \p flags must be a bitwise-or of CUOSeventCreateFlags
 */
int cuosEventIpcCreateWithFlags(cuosEvent *event, char *ipcobj_name, cuosEventMode_t mode, unsigned int flags);

/* Destroy a cuosEvent. */
int cuosEventDestroy(cuosEvent *event);

// File operations
//

int cuosReadLockFile(FILE *stream, unsigned int waitForMs);
int cuosWriteLockFile(FILE *stream, unsigned int waitForMs);

/* Acquire a lock on a file. Wait some number of milliseconds before failing. */
int cuosLockFile(FILE *stream, unsigned int waitForMs);

/* Unlock a file locked by cuosLockFile. */
int cuosUnlockFile(FILE *stream);

/* Return the size in bytes of a file. */
long long cuosGetFileSize(const char *path);

/** Opens a file with read permissions. */
#define CUOS_OPEN_READ    0x1

/** Opens a file with write persmissions. */
#define CUOS_OPEN_WRITE   0x2

/** Creates a file if is not present on the file system. */
#define CUOS_OPEN_CREATE  0x4

/** Open file in append mode. Implies WRITE. */
#define CUOS_OPEN_APPEND  0x8


/** Opens a file stream.
 *
 *  If the ::CUOS_OPEN_CREATE flag is specified, ::CUOS_OPEN_WRITE must also
 *  be specified.
 *
 *  If \c CUOS_OPEN_WRITE is specified, the file will be opened for write and
 *  will be truncated if it was previously existing.
 *
 *  If \c CUOS_OPEN_WRITE and ::CUOS_OPEN_READ are specified, the file will not
 *  be truncated.
 *
 *  @param path A pointer to the path to the file.
 *  @param flags Or'd flags for the open operation (\c CUOS_OPEN_*).
 *  @param [out] file A pointer to the file that will be opened, if successful.
 */
int cuosFopen(const char *path, unsigned long flags, cuosFileHandle *stream);

/** Closes a file stream.
 *
 *  @param stream The file stream to close.
 *  Passing in a null handle is okay.
 */
void cuosFclose(cuosFileHandle stream);

/** Writes to a file stream.
 *
 *  @param stream The file stream.
 *  @param ptr A pointer to the data to write.
 *  @param size The length of the write.
 *
 *  @retval CUOS_ERROR Returned on error.
 */
int
cuosFwrite(cuosFileHandle stream, const void *ptr, size_t size);

/** Reads a file stream.
 *
 *  Buffered read implementation if available for a particular OS may
 *  return corrupted data if multiple threads read from the same
 *  stream simultaneously.
 *
 *  To detect short reads (less that specified amount), pass in \a bytes
 *  and check its value to the expected value. The \a bytes parameter may
 *  be null.
 *
 *  @param stream The file stream.
 *  @param ptr A pointer to the buffer for the read data.
 *  @param size The length of the read.
 *  @param [out] bytes A pointer to the number of bytes readd; may be null.
 *
 *  @retval CUOS_ERROR if the file read encountered any
 *      system errors.
 *  @retval CUOS_EOF Indicates end of file reached. Bytes
 *      must be checked to determine whether data was read into the
 *      buffer.
 */
int
cuosFread(cuosFileHandle stream, void *ptr, size_t size, size_t *bytes);

/** Gets a character from a file stream.
 *
 *  @param stream The file stream.
 *  @param [out] c A pointer to the character from the file stream.
 *
 *  @retval CUOS_EOF When the end of file is reached.
 */
int
cuosFgetc(cuosFileHandle stream, char *c);

/** Changes the file position pointer.
 *
 *  @param file The file.
 *  @param offset The offset from whence to seek.
 *  @param whence The starting point for the seek.
 *
 *  @retval CUOS_EOF On error.
 */
int
cuosFseek(cuosFileHandle stream, unsigned long long offset, cuosSeekEnum whence);

/** Gets the current file position pointer.
 *
 *  @param file The file.
 *  @param [out] position A pointer to the file position.
 *
 *  @retval CUOS_ERROR On error.
 */
int
cuosFtell(cuosFileHandle stream, unsigned long long *position);

/** Flushes any pending writes to the file stream.
 *
 *  @param stream The file stream.
 */
int
cuosFflush_internal(cuosFileHandle stream);

/* Create a directory with default permissions. */
int cuosMkdir(const char* path);

/* Remove a directory. */
int cuosRmdir(const char *path);

/* Remove a file. */
int cuosRm(const char *path);

/* Remove recusively a directory */
int cuosRmdirRecursive(const char *path);

/* Get the path to the user data directory. */
void cuosGetUserDataNVPath(char *buffer, size_t bufferSize);

/* Get the current working directory */
int cuosGetcwd(char *buffer, size_t bufferSize);

CUOSLibrary cuosLoadLibrary(const char *name);
CUOSLibrary cuosLoadLibraryUnsafe(const char *name);
int cuosFreeLibrary(CUOSLibrary lib);
void (*cuosGetProcAddress(CUOSLibrary lib, const char *name))(void);

void cuosResetTimer(cuosTimer *timer);
//Return the elapsed time, in ms, since the timer was reset
float cuosGetTimer(cuosTimer *timer);

//Return the current cpu time in ns
unsigned long long cuosGetCpuTime (void);

void cuosGetLocalTime(cuosLocalTime *localTime);

int cuosSetEnv(const char* env, const char *val);

// Platform independent version of getenv.
// Arguments:
// env - name of environment variable
// val - the buffer where environment variable will be copied.
// size - the size of the buffer.
// Returns:
// -1:              an error, or the environment variable does not exist.
// 0:               success, the copied variable is in val.
// positive number: variable does not fit in the buffer, the returned number
//                  indicates the length in bytes of the variable.
int cuosGetEnv(const char* env, char *val, size_t size);

// Routine for getting the system page size
unsigned int cuosGetPageSize(void);

typedef enum CUOSvirtualAllocFlags_enum
{
    CUOS_VIRTUAL_ALLOC_INVALID             = 0,
    // Reserve memory but do not commit it
    CUOS_VIRTUAL_ALLOC_RESERVE             = 1,
    // Commit an already-reserved address
    CUOS_VIRTUAL_ALLOC_COMMIT              = 2,
    // Reserve memory and commit it
    CUOS_VIRTUAL_ALLOC_RESERVE_AND_COMMIT  = 3,
} CUOSvirtualAllocFlags;
typedef enum CUOSvirtualAccessFlags_enum
{
    // Read-write access
    CUOS_VIRTUAL_ACCESS_DEFAULT      = 0,
    // Disable CPU caching
    CUOS_VIRTUAL_ACCESS_UNCACHED     = 1,
    // Enable write-combine
    CUOS_VIRTUAL_ACCESS_WRITECOMBINE = 2,
    // No access (for reservations)
    CUOS_VIRTUAL_ACCESS_NONE         = 3,
} CUOSvirtualAccessFlags;
void *cuosVirtualAlloc(void *addr, size_t size, unsigned int allocFlags, unsigned int accessFlags);

// Allocate a VA space at the provided hint address with restrictions on base, limit, and align
// Additionally, the hintAddr (if specified) and base need to match the limit and alignment restrictions
// However, this function is free to return VA's at any address that that match these requirements
// Return NULL if no such VA can be found by the OS.
void *cuosVirtualAllocInRange(void *hintAddr, size_t size, unsigned int allocFlags, unsigned int accessFlags,
                              void* base, void *limit, size_t align);

void *cuosVirtualReserveInRange(size_t size, void *base, void* limit, size_t align);

// Find a free VA that meets the base, limit, size and align requirements
// Note that a subsequent cuosVirtualAlloc() of it is not guaranteed to work.
// Return NULL if no VA can be found.
void *cuosVirtualFindFreeVaInRange(size_t size, void *base, void *limit, size_t align);

typedef enum CUOSvirtualFreeFlags_enum
{
    CUOS_VIRTUAL_FREE_INVALID              = 0,
    // Decommit already-committed memory
    CUOS_VIRTUAL_FREE_DECOMMIT             = 1,
    // Free (and decommit if needed) reserved or committed memory
    CUOS_VIRTUAL_FREE_RELEASE              = 2,
} CUOSvirtualFreeFlags;
void  cuosVirtualFree(void *addr, size_t size, unsigned int freeFlags);

typedef enum CUOSvirtualProtectFlags_enum
{
    // No access
    CUOS_VIRTUAL_PROTECT_NOACCESS      = 0,
    // Read access
    CUOS_VIRTUAL_PROTECT_READ          = 1,
    // Read-write access
    CUOS_VIRTUAL_PROTECT_READWRITE     = 2,
} CUOSvirtualProtectFlags;
int cuosVirtualProtect(void *addr, size_t size, unsigned int protectFlags);

typedef enum CUOSmadviseFlags_enum
{
    CUOS_MADVISE_DONTFORK = 0,
    CUOS_MADVISE_DOFORK   = 1,
} CUOSmadviseFlags;
int cuosMadvise(void *addr, size_t length, unsigned int advice);

// Routines for managing IPC shared memory
void* cuosShmCreate(const char *name, const size_t size);
void* cuosShmOpen(const char *name);
void cuosShmDestroy(void *hMapFile);
void* cuosShmMap(void *hMapFile, const size_t size);
void cuosShmUnmap(void *pMapMemory);
void* cuosShmBaseAddress(const cuosShmInfo *shmInfo);
size_t cuosShmSize(const cuosShmInfo *shmInfo);

/**
 * Creates and maps shared memory of the requested size into process address space
 *
 * If addr is not NULL, the shared memory region will be created at the specified
 * virtual address. If there is insufficient space at addr, cuosShmCreateEx will fail
 */
int cuosShmCreateEx(void *addr, cuosShmKey *key, size_t size, cuosShmInfoEx **shmInfoEx);

/**
 * Same as above. But it takes a char* as the shared memory key
 * key should be in the format of "/<name>"
 */
int cuosShmCreateNamedEx(void *addr, const char *key, size_t size, cuosShmInfoEx **shmInfoEx);

/**
 * Open and map existing shared memory. shmKey should be the key returned by
 * cuosShmCreateEx in shmInfoEx->shmKey. size should match the size passed to
 * cuosShmCreateEx. If there is insufficient space at addr, cuosShmOpenEx will fail
 *
 * If addr is not NULL, the shared memory region will be mapped at the specified
 * virtual address. 
 */
int cuosShmOpenEx(void *addr, cuosShmKey *key, size_t size, cuosShmInfoEx **shmInfoEx);

/**
 * Same as above. But it takes a char* as the shared memory key
 */
int cuosShmOpenNamedEx(void *addr, const char *key, size_t size, cuosShmInfoEx **shmInfoEx);

/**
 * Cleanup shared memory created by cuosShmCreateEx or cuosShmOpenEx. On OSs where 
 * shared memory is implemented through the filesystem, this call will unlink the 
 * backing file if unlink == 1.
 */
void cuosShmCloseEx(cuosShmInfoEx *shmInfoEx, unsigned int shmCloseExFlags, unsigned int unlink);

/**
 * Write 1 to isOwner if the user id (uid on *nix, sid on Windows) of the calling
 * process is the same as that of the owner of the shared memory. Write 0 otherwise.
 */
int cuosShmIsOwner(cuosShmInfoEx *shmInfoEx, int *isOwner);

/* Creates a thread
 * - this thread structure will be destroyed only once both
 *   - the thread has exited and
 *   - the thread has had either join or detach called
 */
int cuosThreadCreate(
    CUOSthread **thread,
    int (*startFunc)(void*),
    void *userData);

int cuosThreadCreateWithName(
    CUOSthread **thread,
    int (*startFunc)(void*),
    void *userData,
    const char *name);

/* Wait for the thread to join, and then free the thread handle */
void cuosThreadJoin(CUOSthread *thread, int *retCode);

/* Indicate that a thread will never be joined on, and its resources may be reclaimed when it exits */
void cuosThreadDetach(CUOSthread *thread);

/* Get the current thread's ID */
CUOSthreadId cuosGetCurrentThreadId(void);

/* Return 1 if the specified thread is current */
int cuosThreadIsCurrent(CUOSthread *thread);

/* Return 1 if the thread ids are equal */
int cuosThreadIdEqual(CUOSthreadId tid1, CUOSthreadId tid2);

/* Return TRUE if the thread has exited; FALSE otherwise.*/
int cuosHasThreadExited(CUOSthread *thread);

/* Get the procesor affinity for the specified thread */
/* If thread is NULL, this function operates on the calling thread */
void cuosGetThreadAffinity(CUOSthread *thread, size_t *mask);

/* Set the processor affinity for the specified thread */
/* If thread is NULL, this function operates on the calling thread */
void cuosSetThreadAffinity(CUOSthread *thread, const size_t *mask);

/* Return the number of bits per word */
#define cuosProcessorMaskWordBits() (8 * sizeof(size_t))

/* Zero-fill a mask */
#define cuosProcessorMaskZero(mask) memset((mask), '\0', cuosProcessorMaskSize())

/* Set a bit in an affinity mask */
#define cuosProcessorMaskSet(mask, proc) \
do { \
    size_t _proc = (proc); \
    (mask)[_proc / cuosProcessorMaskWordBits()] |= (size_t)1 << (_proc % cuosProcessorMaskWordBits()); \
} while (0)

/* Clear a bit in an affinity mask */
#define cuosProcessorMaskClear(mask, proc) \
do { \
    size_t _proc = (proc); \
    (mask)[_proc / cuosProcessorMaskWordBits()] &= ~((size_t)1 << (_proc % cuosProcessorMaskWordBits())); \
} while (0)

/* Return whether two masks are equal */
#define cuosProcessorMaskEqual(mask1, mask2) (memcmp((mask1), (mask2), cuosProcessorMaskSize()) == 0)

/* Return the number of processors present in the system */
unsigned int cuosGetProcessorCount(void);

/* Return the processor upon which the current thread is running */
unsigned int cuosGetCurrentProcessor(void);

/* Returns the maximum number of nodes that the system can support */
unsigned long cuosNumaGetNumPossibleNodes(void);

/* Returns a pointer to the mask of allowed NUMA nodes for this process */
/* The returned pointer must not be accessed beyond cuosNumaGetNumPossibleNodes() bits */
const unsigned long * cuosNumaGetAllowedNodeMask(void);

/* Returns the NUMA node id associated with the given cpu (as returned by cuosGetCurrentProcessor()) */
unsigned long cuosNumaGetNodeIdForProcessor(unsigned int processor);

/* Gets the NUMA memory policy for the calling thread */
/* 'opaqueMode' is the OS-dependent NUMA mode of the process. It can only be used to pass into cuosNumaSetThreadMemPolicy() */
/* 'nodeMask' must be at least cuosNumaGetNumPossibleNodes() bits long */
/* On Linux, the value of errno will be preserved if the call returns CUOS_ERROR */
int cuosNumaGetThreadMemPolicy(int *opaqueMode, unsigned long *nodeMask);

/* Sets the NUMA memory policy for the calling thread */
/* 'opaqueMode' is the OS-dependent NUMA mode of the process. It must be obtained via cuosNumaGetThreadMemPolicy() */
/* 'nodeMask' must be at least cuosNumaGetNumPossibleNodes() bits long */
/* On Linux, the value of errno will be preserved if the call returns CUOS_ERROR */
int cuosNumaSetThreadMemPolicy(int opaqueMode, const unsigned long *nodeMask);

/* Moves the specified 'pages' to the specified 'nodes'. Any errors are returned in 'status' */
/* If nodes is NULL, then the location of each page is returned in status */
/* On Linux, the value of errno will be preserved if the call returns CUOS_ERROR */
int cuosNumaMovePages(unsigned long count, void **pages, const int *nodes, int *status);

/* Create a semaphore */
int cuosSemaphoreCreate(cuosSem *sem, int value);

/* Delete  a semaphore */
int cuosSemaphoreDestroy(cuosSem *sem);

/* Wait for a semaphore, for up to the specified time in milliseconds.
 * Returns:
 * CUOS_SUCCESS - The semaphore was obtained.
 * CUOS_TIMEOUT - [timeoutMs] milliseconds expired before the semaphore
 *                could be obtained. This will never be returned if
 *                [timeoutMs] was specified as CUOS_INFINITE_TIMEOUT.
 * CUOS_ERROR   - Some other error occured.
 */
int cuosSemaphoreWait(cuosSem *sem, unsigned int timeoutMs);

/* Signal semaphore */
int cuosSemaphoreSignal(cuosSem *sem);

// Condition variables. Valid return codes are CUOS_SUCCESS, CUOS_ERROR, and
// in the case of cuosCondWait CUOS_TIMEOUT. Note that cuosCondWait follows
// standard condition variable semantics in that it may return spuriously prior
// to actually being signaled. In this case it will return CUOS_SUCCESS, so the
// app must check a predicate to see if the condition for which it's waiting has
// happened.
int cuosCondCreate(cuosCV *cv);
int cuosCondCreateShared(cuosCV *cv);
int cuosCondWait(cuosCV *cv, CUOSCriticalSection *mutex, unsigned int timeoutMs);
int cuosCondSignal(cuosCV *cv);
int cuosCondBroadcast(cuosCV *cv);
int cuosCondDestroy(cuosCV *cv);

// Thread barrier. Any call to cuosBarrierWait on a given barrier will block
// until limit threads have all called cuosBarrierWait, at which point the
// barrier will be reset and the wait call will return to all threads with
// CUOS_SUCCESS if no error has occurred.
int cuosBarrierCreate(cuosBarrier *barrier, unsigned int limit);
int cuosBarrierWait(cuosBarrier *barrier);
int cuosBarrierDestroy(cuosBarrier *barrier);

/**
 * CUOSsocket
 */

// CUOSsocket is implemented for Linux abstract domain sockets only at the moment.
// See the comments in cuosLinux.cpp for details on these functions
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

/**
 *
 * CUOSpipe
 *
 */

// CUOSpipe is for inter-process client-server communication. It has two modes, similar to TCP and UDP sockets.

// For both TCP mode and UDP mode, the server process calls cuosPipeOpenAsServer() first to open a server pipe.
// This call does not block.
// accessControl - specify who can access this server pipe. If accessControl is NULL, then everyone can access it.
//                 On Linux: accessControl is (mode_t *), specifying file permissions.
int cuosPipeOpenAsServer(const char *serverPipeName, void *accessControl, CUOSpipe *newPipe);

// Only used in TCP mode. This call blocks until some client calls cuosPipeOpenAsClient() to connect
int cuosPipeAcceptClient(CUOSpipe *serverPipe, CUOSpipe *newClientPipe);

// -UDP mode: If clientPipeName is NULL, no client private pipe is created, the new pipe returned
//            is for writing to server only. It's useful for things like sending log messages to server.
// -TCP mode: If clientPipeName is not NULL, two private pipes (read/write on both directions) for
//            this client are created. If server exists, the call blocks until server calls cuosPipeAcceptClient(),
//            otherwise, the call fails and return immediately.
// All clients of a server must be using the same mode.
int cuosPipeOpenAsClient(const char *serverPipeName, const char *clientPipeName, CUOSpipe *newPipe);

// Common operations on pipe. Read/Write blocks
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

// Get path to the current process
// Arguments:
// path - will be set to the newly allocated buffer containing the path (has to be freed by the caller)
// Returns CUOS_SUCCESS or CUOS_ERROR
int cuosGetCurrentProcessExecPath(char **path);

// Memory allocations which allows checking if deallocation during teardown is safe.
// For more details see https://nvcompute/index.php/Cudart/Initialization#Case_1:_Memory
void *cuosMalloc(size_t size);
void cuosFree(void *ptr);
void *cuosCalloc(size_t nmemb, size_t size);
void *cuosRealloc(void *ptr, size_t size);
// Locks needed for Windows to be teardown-safe
int cuosMemoryStartTeardown(void);
// Consumers can do an explicit retain/release of resources needed by this
// cuos instance's memory allocator to avoid destruction ordering issues.
// There is also an implicit retain/release done by a static initializer
// and atexit handler within cuos.  Note that the allocator is not tied
// to any other internal cuos resources which are destroyed in cuos dtors,
// as long as cuos is in the same module as the consumer.
void cuosMemoryRetain(void);
void cuosMemoryRelease(void);
/*
 * Get the hostname as a null-terminated string.
 * Linux/Mac: If the name array is not big enough, a partial hostname is returned.
 * Windows: If the name array is not big enough, an error is retuned.
 */
int cuosGetHostname(char *name, size_t length);

char *cuosStrdup(const char *str);
size_t cuosStrlen(const char *str);

// Intersect two ranges and align the start of the intersection. For an empty intersection returned start will be equal to end.
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

// Set thread name
int cuosSetThreadName(CUOSthread *thread, const char *name);

#ifdef __HOS__
typedef void* (*cuosNNAllocateCallback_t)(size_t size, size_t align, void *userPtr);
typedef void (*cuosNNFreeCallback_t)(void *addr, void *userPtr);
typedef void* (*cuosNNReallocateCallback_t)(void *addr, size_t newSize, void *userPtr);

// Set application memory allocator callbacks. These callbacks would be called by driver if driver calls mallc/calloc/realloc.
int cuosSetHosAllocator(cuosNNAllocateCallback_t allocateCb, cuosNNFreeCallback_t freeCb, cuosNNReallocateCallback_t reallocateCb, void *userPtr);
int cuosIsHosAllocatorInitialized(void);
#endif


#if defined(__cplusplus)
} // namespace or extern "C"
#endif

#endif // !NV_MODS

// The default buffer length for environment variable
#define CUOS_ENV_VAR_LENGTH 1024

#endif //_CUOS_H_
