

#ifndef _CUOS_H_
#error "Use cuos.h, not cuos_*.h"
#endif

#ifndef _CUOS_COMMON_POSIX_H_
#define _CUOS_COMMON_POSIX_H_

#include <pthread.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/types.h>
#include <dlfcn.h>

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

typedef pthread_key_t CUOSTLSEntry;
typedef pthread_mutex_t CUOSCriticalSection;
typedef void *CUOSRWLock;
typedef pthread_cond_t cuosCV;
typedef pthread_once_t cuosOnceControl;
typedef void *CUOSLibrary;
typedef pid_t CUOSPid;
typedef uid_t CUOSUid;
typedef gid_t CUOSGid;
typedef pthread_t CUOSthreadId;
typedef FILE* cuosFileHandle;
typedef int CUOSFileDescriptor;

#define CUOS_ROOT_UID 0

#define CUOS_ONCE_INIT PTHREAD_ONCE_INIT

#define CUOS_TLS_OUT_OF_INDEXES 0

struct cuosShmInfoEx_st
{
    char *name;     
    cuosShmKey key; 
    void *addr;     
    size_t size;    

    int fd;         
    uid_t uid;      
};

#if defined (__i386__) || defined(__x86_64__)



#define cuosDebugBreak()       asm volatile("int $0x3" : : : "memory")
#define cuosStoreFence()       asm volatile("sfence" : : : "memory")
#define cuosLoadFence()        asm volatile("lfence" : : : "memory")
#define cuosMemFence()         asm volatile("mfence" : : : "memory")
#define cuosPauseInstruction() asm volatile("pause")
#define cuosIsRelaxedMemoryModel() 0

#elif defined(__arm__)

#ifdef __thumb__
#define cuosDebugBreak()       asm volatile("bkpt 0x0" : : : "memory")
#else 
#define cuosDebugBreak()       asm volatile("bkpt 0xf02c" : : : "memory")
#endif 
#define cuosStoreFence()       asm volatile("dmb" : : : "memory")
#define cuosLoadFence()        asm volatile("dmb" : : : "memory")
#define cuosMemFence()         asm volatile("dmb" : : : "memory")
#define cuosPauseInstruction() asm volatile("yield")
#define cuosIsRelaxedMemoryModel() 1

#elif defined(__aarch64__)

#define cuosDebugBreak()       asm volatile("brk 0xf02c" : : : "memory")
#define cuosStoreFence()       asm volatile("dmb st" : : : "memory")
#define cuosLoadFence()        asm volatile("dmb ld" : : : "memory")
#define cuosMemFence()         asm volatile("dmb sy" : : : "memory")
#define cuosPauseInstruction() asm volatile("yield")
#define cuosIsRelaxedMemoryModel() 1

#elif defined(__powerpc64__)

#define cuosDebugBreak()       asm volatile("tweq 1,1" : : : "memory")
#define cuosStoreFence()       asm volatile("sync" : : : "memory")
#define cuosLoadFence()        asm volatile("sync" : : : "memory")
#define cuosMemFence()         asm volatile("sync" : : : "memory")
#define cuosPauseInstruction() asm volatile("or 27,27,27 # shared resource yield")
#define cuosIsRelaxedMemoryModel() 1

#endif

#if !defined(CUOS_ATOMICS_DEFINED) && ((defined(__GNUC__) && (__GNUC__ * 100 + __GNUC_MINOR__) >= 407) || __has_builtin(__atomic_load_4))
#define CUOS_ATOMICS_DEFINED



static unsigned int cuosAtomicReadSeqCst32(volatile const unsigned int *ptr)
{
    return __atomic_load_4(ptr, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicReadAcquire32(volatile const unsigned int *ptr)
{
    return __atomic_load_4(ptr, __ATOMIC_ACQUIRE);
}

static unsigned int cuosAtomicReadRelaxed32(volatile const unsigned int *ptr)
{
    return __atomic_load_4(ptr, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicReadSeqCst64(volatile const unsigned long long *ptr)
{
    return __atomic_load_8(ptr, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicReadAcquire64(volatile const unsigned long long *ptr)
{
    return __atomic_load_8(ptr, __ATOMIC_ACQUIRE);
}

static unsigned long long cuosAtomicReadRelaxed64(volatile const unsigned long long *ptr)
{
    return __atomic_load_8(ptr, __ATOMIC_RELAXED);
}



static void cuosAtomicWriteSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_store_4(ptr, val, __ATOMIC_SEQ_CST);
}

static void cuosAtomicWriteRelease32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_store_4(ptr, val, __ATOMIC_RELEASE);
}

static void cuosAtomicWriteRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_store_4(ptr, val, __ATOMIC_RELAXED);
}

static void cuosAtomicWriteSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_store_8(ptr, val, __ATOMIC_SEQ_CST);
}

static void cuosAtomicWriteRelease64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_store_8(ptr, val, __ATOMIC_RELEASE);
}

static void cuosAtomicWriteRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_store_8(ptr, val, __ATOMIC_RELAXED);
}




static unsigned int cuosAtomicExchangeSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_exchange_4(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicExchangeAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_exchange_4(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned int cuosAtomicExchangeRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_exchange_4(ptr, val, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicExchangeSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_exchange_8(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicExchangeAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{ 
    return __atomic_exchange_8(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned long long cuosAtomicExchangeRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_exchange_8(ptr, val, __ATOMIC_RELAXED);
}





#if (defined(__GNUC__) && (__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__) < 40803)
# define ATOMIC_COMPARE_EXCHANGE_WRAPPER(typeName, typeSize, isWeak, memoryOrderingOnSuccess, memoryOrderingOnFailure)                            \
    do {                                                                                                                                          \
        typeName __expected = *expected;                                                                                                          \
        int __result = __atomic_compare_exchange_##typeSize(ptr, &__expected, desired, isWeak, memoryOrderingOnSuccess, memoryOrderingOnFailure); \
        if (!__result) {                                                                                                                          \
            *expected = __expected;                                                                                                               \
        }                                                                                                                                         \
        return __result;                                                                                                                          \
    } while(0)
#else
# define ATOMIC_COMPARE_EXCHANGE_WRAPPER(typeName, typeSize, isWeak, memoryOrderingOnSuccess, memoryOrderingOnFailure) \
    return __atomic_compare_exchange_##typeSize(ptr, expected, desired, isWeak, memoryOrderingOnSuccess, memoryOrderingOnFailure);
#endif






static int cuosAtomicCompareExchangeWeakSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 1, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeWeakAcqRel32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 1, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeWeakRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 1, __ATOMIC_RELAXED, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeWeakSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 1, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeWeakAcqRel64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected) 
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 1, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeWeakRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 1, __ATOMIC_RELAXED, __ATOMIC_RELAXED);
}





static int cuosAtomicCompareExchangeStrongSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
}

static int cuosAtomicCompareExchangeStrongAcqRel32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 0, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE);
}

static int cuosAtomicCompareExchangeStrongRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned int, 4, 0, __ATOMIC_RELAXED, __ATOMIC_RELAXED);
}

static int cuosAtomicCompareExchangeStrongSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
}

static int cuosAtomicCompareExchangeStrongAcqRel64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 0, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE);
}

static int cuosAtomicCompareExchangeStrongRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    ATOMIC_COMPARE_EXCHANGE_WRAPPER(unsigned long long, 8, 0, __ATOMIC_RELAXED, __ATOMIC_RELAXED);
}




static unsigned int cuosAtomicFetchAndIncrementSeqCst32(volatile unsigned int *ptr)
{
    return __atomic_fetch_add_4(ptr, 1, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicFetchAndIncrementAcqRel32(volatile unsigned int *ptr)
{
    return __atomic_fetch_add_4(ptr, 1, __ATOMIC_ACQ_REL);
}

static unsigned int cuosAtomicFetchAndIncrementRelaxed32(volatile unsigned int *ptr)
{
    return __atomic_fetch_add_4(ptr, 1, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicFetchAndIncrementSeqCst64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_add_8(ptr, 1, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicFetchAndIncrementAcqRel64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_add_8(ptr, 1, __ATOMIC_ACQ_REL);
}

static unsigned long long cuosAtomicFetchAndIncrementRelaxed64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_add_8(ptr, 1, __ATOMIC_RELAXED);
}




static unsigned int cuosAtomicFetchAndDecrementSeqCst32(volatile unsigned int *ptr)
{
    return __atomic_fetch_sub_4(ptr, 1, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicFetchAndDecrementAcqRel32(volatile unsigned int *ptr)
{
    return __atomic_fetch_sub_4(ptr, 1, __ATOMIC_ACQ_REL);
}

static unsigned int cuosAtomicFetchAndDecrementRelaxed32(volatile unsigned int *ptr)
{
    return __atomic_fetch_sub_4(ptr, 1, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicFetchAndDecrementSeqCst64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_sub_8(ptr, 1, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicFetchAndDecrementAcqRel64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_sub_8(ptr, 1, __ATOMIC_ACQ_REL);
}

static unsigned long long cuosAtomicFetchAndDecrementRelaxed64(volatile unsigned long long *ptr)
{
    return __atomic_fetch_sub_8(ptr, 1, __ATOMIC_RELAXED);
}




static unsigned int cuosAtomicFetchAndOrSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_or_4(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicFetchAndOrAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_or_4(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned int cuosAtomicFetchAndOrRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_or_4(ptr, val, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicFetchAndOrSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_or_8(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicFetchAndOrAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_or_8(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned long long cuosAtomicFetchAndOrRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_or_8(ptr, val, __ATOMIC_RELAXED);
}




static unsigned int cuosAtomicFetchAndAndSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_and_4(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned int cuosAtomicFetchAndAndAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_and_4(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned int cuosAtomicFetchAndAndRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return __atomic_fetch_and_4(ptr, val, __ATOMIC_RELAXED);
}

static unsigned long long cuosAtomicFetchAndAndSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_and_8(ptr, val, __ATOMIC_SEQ_CST);
}

static unsigned long long cuosAtomicFetchAndAndAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_and_8(ptr, val, __ATOMIC_ACQ_REL);
}

static unsigned long long cuosAtomicFetchAndAndRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __atomic_fetch_and_8(ptr, val, __ATOMIC_RELAXED);
}

#elif !defined(CUOS_ATOMICS_DEFINED) && ((defined(__GNUC__) && (__GNUC__ * 1000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__) >= 40102) || __has_builtin(__sync_synchronize))
#define CUOS_ATOMICS_DEFINED







#define cuosAtomicCompareExchangeWeakSeqCst32    cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakAcqRel32    cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakRelaxed32   cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakSeqCst64    cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeWeakAcqRel64    cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeWeakRelaxed64   cuosAtomicCompareExchangeStrongSeqCst64





static int cuosAtomicCompareExchangeStrongSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = __sync_val_compare_and_swap_4(ptr, _expected, desired);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeStrongAcqRel32  cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeStrongRelaxed32 cuosAtomicCompareExchangeStrongSeqCst32

static int cuosAtomicCompareExchangeStrongSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result =  __sync_val_compare_and_swap_8(ptr, *expected, desired);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeStrongAcqRel64  cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeStrongRelaxed64 cuosAtomicCompareExchangeStrongSeqCst64




static unsigned int cuosAtomicExchangeSeqCst32 (volatile unsigned int *ptr, const unsigned int val)
{
#if defined(__i386__) || defined(__x86_64__)
    
    
    return __sync_lock_test_and_set(ptr, val);
#else 
    unsigned int tmp;
    do {
        tmp = *ptr;
    } while(!cuosAtomicCompareExchangeWeakSeqCst32(ptr, val, &tmp));
    return tmp;
#endif 
}

#define cuosAtomicExchangeAcqRel32  cuosAtomicExchangeSeqCst32
#define cuosAtomicExchangeRelaxed32 cuosAtomicExchangeSeqCst32

static unsigned long long cuosAtomicExchangeSeqCst64 (volatile unsigned long long *ptr, const unsigned long long val)
{
#if defined(__x86_64__)
    
    
    return __sync_lock_test_and_set(ptr, val);
#else 
    unsigned long long tmp;
    do {
        tmp = *ptr;
    } while(!cuosAtomicCompareExchangeWeakSeqCst64(ptr, val, &tmp));
    return tmp;
#endif 
}

#define cuosAtomicExchangeAcqRel64  cuosAtomicExchangeSeqCst64
#define cuosAtomicExchangeRelaxed64 cuosAtomicExchangeSeqCst64





static void cuosAtomicWriteSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    *ptr = val;
    cuosMemFence();
}

static void cuosAtomicWriteRelease32(volatile unsigned int *ptr, const unsigned int val)
{
    if (cuosIsRelaxedMemoryModel()) {
        cuosStoreFence();
    }
    *ptr = val;
}

static void cuosAtomicWriteRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    *ptr = val;
}

#if defined(__LP64__)

static void cuosAtomicWriteSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    *ptr = val;
    cuosMemFence();
}

static void cuosAtomicWriteRelease64(volatile unsigned long long *ptr, const unsigned long long val)
{
    if (cuosIsRelaxedMemoryModel()) {
        cuosStoreFence();
    }
    *ptr = val;
}

static void cuosAtomicWriteRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    *ptr = val;
}

#else 



static void cuosAtomicWriteSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    cuosAtomicExchangeSeqCst64(ptr, val);
}

static void cuosAtomicWriteRelease64(volatile unsigned long long *ptr, const unsigned long long val)
{
    cuosAtomicExchangeAcqRel64(ptr, val);
}

static void cuosAtomicWriteRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    cuosAtomicExchangeRelaxed64(ptr, val);
}

#endif 




static unsigned int cuosAtomicFetchAndIncrementSeqCst32(volatile unsigned int *ptr)
{
    return __sync_fetch_and_add_4(ptr, 1);
}

#define cuosAtomicFetchAndIncrementAcqRel32  cuosAtomicFetchAndIncrementSeqCst32
#define cuosAtomicFetchAndIncrementRelaxed32 cuosAtomicFetchAndIncrementSeqCst32

static unsigned long long cuosAtomicFetchAndIncrementSeqCst64(volatile unsigned long long *ptr)
{
    return __sync_fetch_and_add_8(ptr, 1);
}

#define cuosAtomicFetchAndIncrementAcqRel64  cuosAtomicFetchAndIncrementSeqCst64
#define cuosAtomicFetchAndIncrementRelaxed64 cuosAtomicFetchAndIncrementSeqCst64




static unsigned int cuosAtomicFetchAndDecrementSeqCst32(volatile unsigned int *ptr)
{
    return __sync_fetch_and_sub_4(ptr, 1);
}

#define cuosAtomicFetchAndDecrementAcqRel32  cuosAtomicFetchAndDecrementSeqCst32
#define cuosAtomicFetchAndDecrementRelaxed32 cuosAtomicFetchAndDecrementSeqCst32

static unsigned long long cuosAtomicFetchAndDecrementSeqCst64(volatile unsigned long long *ptr)
{
    return __sync_fetch_and_sub_8(ptr, 1);
}

#define cuosAtomicFetchAndDecrementAcqRel64  cuosAtomicFetchAndDecrementSeqCst64
#define cuosAtomicFetchAndDecrementRelaxed64 cuosAtomicFetchAndDecrementSeqCst64




static unsigned int cuosAtomicFetchAndOrSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __sync_fetch_and_or_4(ptr, val);
}

#define cuosAtomicFetchAndOrAcqRel32  cuosAtomicFetchAndOrSeqCst32
#define cuosAtomicFetchAndOrRelaxed32 cuosAtomicFetchAndOrSeqCst32

static unsigned long long cuosAtomicFetchAndOrSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __sync_fetch_and_or_8(ptr, val);
}

#define cuosAtomicFetchAndOrAcqRel64  cuosAtomicFetchAndOrSeqCst64
#define cuosAtomicFetchAndOrRelaxed64 cuosAtomicFetchAndOrSeqCst64




static unsigned int cuosAtomicFetchAndAndSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return __sync_fetch_and_and_4(ptr, val);
}

#define cuosAtomicFetchAndAndAcqRel32  cuosAtomicFetchAndAndSeqCst32
#define cuosAtomicFetchAndAndRelaxed32 cuosAtomicFetchAndAndSeqCst32

static unsigned long long cuosAtomicFetchAndAndSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return __sync_fetch_and_and_8(ptr, val);
}

#define cuosAtomicFetchAndAndAcqRel64  cuosAtomicFetchAndAndSeqCst64
#define cuosAtomicFetchAndAndRelaxed64 cuosAtomicFetchAndAndSeqCst64



static unsigned int cuosAtomicReadSeqCst32(volatile const unsigned int *ptr)
{
    unsigned int v;
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    v = *ptr;
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    return v;
}

static unsigned int cuosAtomicReadAcquire32(volatile const unsigned int *ptr)
{
    unsigned int v;
    v = *ptr;
    if (cuosIsRelaxedMemoryModel()) {
        cuosLoadFence();
    }
    return v;
}

static unsigned int cuosAtomicReadRelaxed32(volatile const unsigned int *ptr)
{
    return *ptr;
}

#if defined(__LP64__)

static unsigned long long cuosAtomicReadSeqCst64(volatile const unsigned long long *ptr)
{
    unsigned long long v;
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    v = *ptr;
    if (cuosIsRelaxedMemoryModel()) {
        cuosMemFence();
    }
    return v;
}

static unsigned long long cuosAtomicReadAcquire64(volatile const unsigned long long *ptr)
{
    unsigned long long v;
    v = *ptr;
    if (cuosIsRelaxedMemoryModel()) {
        cuosLoadFence();
    }
    return v;
}

static unsigned long long cuosAtomicReadRelaxed64(volatile const unsigned long long *ptr)
{
    return *ptr;
}

#else 



GCC_DIAG_PRAGMA(push)
CLANG_DIAG_PRAGMA(push)


GCC_DIAG_PRAGMA(ignored "-Wcast-qual")
CLANG_DIAG_PRAGMA(ignored "-Wcast-qual")

static unsigned long long cuosAtomicReadSeqCst64(volatile const unsigned long long *ptr)
{
    return cuosAtomicFetchAndOrSeqCst64((volatile unsigned long long *)ptr, 0);
}

static unsigned long long cuosAtomicReadAcquire64(volatile const unsigned long long *ptr)
{
    return cuosAtomicFetchAndOrAcqRel64((volatile unsigned long long *)ptr, 0);
}

static unsigned long long cuosAtomicReadRelaxed64(volatile const unsigned long long *ptr)
{
    return cuosAtomicFetchAndOrRelaxed64((volatile unsigned long long *)ptr, 0);
}

CLANG_DIAG_PRAGMA(pop)
GCC_DIAG_PRAGMA(pop)

#endif 

#else 

#define CUOS_ATOMICS_DEFINED
#define cuosAtomicReadSeqCst32  cuosInterlockedRead
#define cuosAtomicReadRelaxed32 cuosInterlockedRead
#define cuosAtomicReadAcquire32 cuosInterlockedRead
#define cuosAtomicReadSeqCst64  cuosInterlockedRead64
#define cuosAtomicReadRelaxed64 cuosInterlockedRead64
#define cuosAtomicReadAcquire64 cuosInterlockedRead64


unsigned int cuosInterlockedExchange(volatile unsigned int *v, unsigned int exchange);
static unsigned long long cuosInterlockedExchange64(volatile unsigned long long *v, unsigned long long exchange);

static void cuosAtomicWriteSeqCst32(volatile unsigned int *ptr, unsigned int val)
{
    (void)cuosInterlockedExchange(ptr,val);
}

static void cuosAtomicWriteRelease32(volatile unsigned int *ptr, unsigned int val)
{
    (void)cuosInterlockedExchange(ptr,val);
}

static void cuosAtomicWriteRelaxed32(volatile unsigned int *ptr, unsigned int val)
{
    (void)cuosInterlockedExchange(ptr,val);
}

static void cuosAtomicWriteSeqCst64(volatile unsigned long long *ptr, unsigned long long val)
{
    (void)cuosInterlockedExchange64(ptr,val);
}

static void cuosAtomicWriteRelease64(volatile unsigned long long *ptr, unsigned long long val)
{
    (void)cuosInterlockedExchange64(ptr,val);
}

static void cuosAtomicWriteRelaxed64(volatile unsigned long long *ptr, unsigned long long val)
{
    (void)cuosInterlockedExchange64(ptr,val);
}

#define cuosAtomicExchangeSeqCst32  cuosInterlockedExchange
#define cuosAtomicExchangeRelaxed32 cuosInterlockedExchange
#define cuosAtomicExchangeAcqRel32  cuosInterlockedExchange
#define cuosAtomicExchangeSeqCst64  cuosInterlockedExchange64
#define cuosAtomicExchangeRelaxed64 cuosInterlockedExchange64
#define cuosAtomicExchangeAcqRel64  cuosInterlockedExchange64


unsigned int        cuosInterlockedCompareExchange(volatile unsigned int *ptr,
                                                   unsigned int exchange,
                                                   unsigned int compare);
unsigned long long  cuosInterlockedCompareExchange64(volatile unsigned long long *ptr,
                                                     unsigned long long exchange,
                                                     unsigned long long compare);

static int cuosAtomicCompareExchangeStrongSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = cuosInterlockedCompareExchange(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

static int cuosAtomicCompareExchangeStrongSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result = cuosInterlockedCompareExchange64(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeWeakSeqCst32  cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakRelaxed32 cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakAcqRel32  cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeWeakSeqCst64  cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeWeakRelaxed64 cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeWeakAcqRel64  cuosAtomicCompareExchangeStrongSeqCst64

#define cuosAtomicCompareExchangeStrongSeqCst32  cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeStrongRelaxed32 cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeStrongAcqRel32  cuosAtomicCompareExchangeStrongSeqCst32
#define cuosAtomicCompareExchangeStrongSeqCst64  cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeStrongRelaxed64 cuosAtomicCompareExchangeStrongSeqCst64
#define cuosAtomicCompareExchangeStrongAcqRel64  cuosAtomicCompareExchangeStrongSeqCst64


unsigned int cuosInterlockedIncrement(volatile unsigned int *ptr);
unsigned long long cuosInterlockedIncrement64(volatile unsigned long long *ptr);

static unsigned int cuosAtomicFetchAndIncrementSeqCst32(volatile unsigned int *ptr)
{
    return cuosInterlockedIncrement(ptr) - 1;
}

static unsigned int cuosAtomicFetchAndIncrementAcqRel32(volatile unsigned int *ptr)
{
    return cuosInterlockedIncrement(ptr) - 1;
}

static unsigned int cuosAtomicFetchAndIncrementRelaxed32(volatile unsigned int *ptr)
{
    return cuosInterlockedIncrement(ptr) - 1;
}

static unsigned long long cuosAtomicFetchAndIncrementSeqCst64(volatile unsigned long long *ptr)
{
    return cuosInterlockedIncrement64(ptr) - 1;
}

static unsigned long long cuosAtomicFetchAndIncrementAcqRel64(volatile unsigned long long *ptr)
{
    return cuosInterlockedIncrement64(ptr) - 1;
}

static unsigned long long cuosAtomicFetchAndIncrementRelaxed64(volatile unsigned long long *ptr)
{
    return cuosInterlockedIncrement64(ptr) - 1;
}


unsigned int cuosInterlockedDecrement(volatile unsigned int *ptr);
unsigned long long cuosInterlockedDecrement64(volatile unsigned long long *ptr);

static unsigned int cuosAtomicFetchAndDecrementSeqCst32(volatile unsigned int *ptr)
{
    return cuosInterlockedDecrement(ptr) + 1;
}

static unsigned int cuosAtomicFetchAndDecrementAcqRel32(volatile unsigned int *ptr)
{
    return cuosInterlockedDecrement(ptr) + 1;
}

static unsigned int cuosAtomicFetchAndDecrementRelaxed32(volatile unsigned int *ptr)
{
    return cuosInterlockedDecrement(ptr) + 1;
}

static unsigned long long cuosAtomicFetchAndDecrementSeqCst64(volatile unsigned long long *ptr)
{
    return cuosInterlockedDecrement64(ptr) + 1;
}

static unsigned long long cuosAtomicFetchAndDecrementAcqRel64(volatile unsigned long long *ptr)
{
    return cuosInterlockedDecrement64(ptr) + 1;
}

static unsigned long long cuosAtomicFetchAndDecrementRelaxed64(volatile unsigned long long *ptr)
{
    return cuosInterlockedDecrement64(ptr) + 1;
}

#define cuosAtomicFetchAndOrSeqCst32  cuosInterlockedOr
#define cuosAtomicFetchAndOrRelaxed32 cuosInterlockedOr
#define cuosAtomicFetchAndOrAcqRel32  cuosInterlockedOr
#define cuosAtomicFetchAndOrSeqCst64  cuosInterlockedOr64
#define cuosAtomicFetchAndOrRelaxed64 cuosInterlockedOr64
#define cuosAtomicFetchAndOrAcqRel64  cuosInterlockedOr64

#define cuosAtomicFetchAndAndSeqCst32  cuosInterlockedAnd
#define cuosAtomicFetchAndAndRelaxed32 cuosInterlockedAnd
#define cuosAtomicFetchAndAndAcqRel32  cuosInterlockedAnd
#define cuosAtomicFetchAndAndSeqCst64  cuosInterlockedAnd64
#define cuosAtomicFetchAndAndRelaxed64 cuosInterlockedAnd64
#define cuosAtomicFetchAndAndAcqRel64  cuosInterlockedAnd64

#endif 

struct CUOSpipe_st
{
    int readFd;
    int writeFd;
    FILE *readStream;
    FILE *writeStream;
    char *serverPipeName;
};

void cuosPosixInit(void);


int cuosGetRandomBytes(void *buf, size_t len);

#define cuosIsWindowsXp() 0
#define cuosIsWindowsVistaPlus() 0
#define cuosIsWindows7Plus() 0
#define cuosIsWindows8Plus() 0
#define cuosIsWindows8Point1Plus() 0
#define cuosIsWindows10Plus() 0
#define cuosIsWindows10RS2Plus() 0
#define cuosIsWindows10RS4Plus() 0

#if defined(__cplusplus)
} 
#endif

#if defined(__cplusplus)
template<typename T>
class CUOSdlsymLoader
{
public:
    CUOSdlsymLoader(const char *sym, const char *lib = NULL) : val(NULL) {
        dlerror();
        libhnd = dlopen(lib, RTLD_LAZY | RTLD_LOCAL);
        if (!libhnd) {
            return;
        }
        val = (T)dlsym(libhnd, sym);
        if (dlerror()) {
            cleanup();
        }
    }
    ~CUOSdlsymLoader() {
        cleanup();
    }
    const T &operator*() const {
        return val;
    }
private:
    void cleanup() {
        if (libhnd) {
            dlclose(libhnd);
            libhnd = NULL;
            val = NULL;
        }
    }

    void *libhnd;
    T val;
};
#endif

#endif 
