

#ifndef _CUOS_H_
#error "Use cuos.h, not cuos_*.h"
#endif

#ifndef _CUOS_WIN32_H_
#define _CUOS_WIN32_H_


#if !defined(_WIN32_WINNT)
#   define _WIN32_WINNT 0x0601
#elif defined(_WIN32_WINNT) && _WIN32_WINNT == 0x0600
#   pragma message("Windows SDK version is defined to Vista but it should be Win7")
#elif defined(_WIN32_WINNT) && _WIN32_WINNT < 0x0600
#   error "Windows SDK version is incorrectly defined"
#endif


#define snprintf _snprintf

#if (MSC_VER < 1400)
#define vsnprintf _vsnprintf
#endif


#define __PRETTY_FUNCTION__ __FUNCSIG__

#include <windows.h>
#include <process.h>

#if defined(_WIN32_WINNT_WIN8)
#   if _WIN32_WINNT_WIN8 != 0x0602
#       error "_WIN32_WINNT_WIN8 is incorrectly defined"
#   endif
#else
#   define _WIN32_WINNT_WIN8 0x0602
#endif

#if defined(_M_IX86)
#include <intrin.h>
#endif

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

typedef DWORD CUOSTLSEntry;
typedef CRITICAL_SECTION CUOSCriticalSection;
typedef SRWLOCK CUOSRWLock;
typedef HMODULE CUOSLibrary;
typedef HANDLE cuosSem;
typedef DWORD CUOSPid;
typedef DWORD CUOSthreadId;
typedef FILE* cuosFileHandle;
typedef HANDLE CUOSFileDescriptor;

#define CUOS_ONCE_INIT 0
typedef unsigned int cuosOnceControl;

typedef struct cuostimer {
    LARGE_INTEGER t;
} cuosTimer;

typedef struct cvListNode_st cvListNode;

typedef struct cuosCV_st {
    CONDITION_VARIABLE hCV;
} cuosCV;

typedef struct cuosEvent {
    int createdByCuos;
    HANDLE hEvent;
} cuosEvent;




typedef enum {
    CUOS_EVENT_SIGNAL_MODE          = 1,
    CUOS_EVENT_WAIT_MODE            = 2
} cuosEventMode_t;

struct cuosShmInfoEx_st
{
    char *name;     
    cuosShmKey key; 
    void *addr;     
    size_t size;    

    HANDLE fh;      
};


#define cuosProcessorMaskSize() (CUOS_ROUND_UP(cuosGetProcessorCount(), cuosProcessorMaskWordBits()) / 8)

#define __thread __declspec(thread) 

#define cuosPauseInstruction()  YieldProcessor()

#define CUOS_TLS_OUT_OF_INDEXES TLS_OUT_OF_INDEXES

#define cuosDebugBreak()  __debugbreak()
#define cuosStoreFence()  _mm_sfence()
#define cuosLoadFence()   _mm_lfence()
#define cuosMemFence()    _mm_mfence()

#if defined(_M_ARM) || defined(_M_PPC) || defined(_M_IA64)
#define cuosIsRelaxedMemoryModel() 1
#elif defined(_M_IX86) || defined(_M_X64) || defined(_M_AMD64)
#define cuosIsRelaxedMemoryModel() 0
#endif

#if !defined(CUOS_ATOMICS_DEFINED)
#define CUOS_ATOMICS_DEFINED




static unsigned int cuosAtomicExchangeSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedExchange((volatile long *)ptr, val);
}

static unsigned int cuosAtomicExchangeAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedExchange((volatile long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned int cuosAtomicExchangeRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedExchange((volatile long *)ptr, val);
}

#else 

static unsigned int cuosAtomicExchangeRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedExchangeNoFence((volatile long *)ptr, val);
}

#endif 

static unsigned long long cuosAtomicExchangeSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedExchange64((volatile long long *)ptr, val);
}

static unsigned long long cuosAtomicExchangeAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedExchange64((volatile long long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned long long cuosAtomicExchangeRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedExchange64((volatile long long *)ptr, val);
}

#else 

static unsigned long long cuosAtomicExchangeRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedExchangeNoFence64((volatile long long *)ptr, val);
}

#endif 






static int cuosAtomicCompareExchangeWeakSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = InterlockedCompareExchange(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeWeakAcqRel32 cuosAtomicCompareExchangeWeakSeqCst32

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

#define cuosAtomicCompareExchangeWeakRelaxed32 cuosAtomicCompareExchangeWeakSeqCst32

#else 

static int cuosAtomicCompareExchangeWeakRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = InterlockedCompareExchangeNoFence(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#endif 

static int cuosAtomicCompareExchangeWeakSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result = InterlockedCompareExchange64((volatile long long *)ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeWeakAcqRel64 cuosAtomicCompareExchangeWeakSeqCst64

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

#define cuosAtomicCompareExchangeWeakRelaxed64 cuosAtomicCompareExchangeWeakSeqCst64

#else 

static long long cuosAtomicCompareExchangeWeakRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result = InterlockedCompareExchangeNoFence64((volatile long long *)ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#endif 





static int cuosAtomicCompareExchangeStrongSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = InterlockedCompareExchange(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeStrongAcqRel32 cuosAtomicCompareExchangeStrongSeqCst32

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

#define cuosAtomicCompareExchangeStrongRelaxed32 cuosAtomicCompareExchangeStrongSeqCst32

#else 

static int cuosAtomicCompareExchangeStrongRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    unsigned int _expected = *expected;
    unsigned int result = InterlockedCompareExchangeNoFence(ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#endif 

static int cuosAtomicCompareExchangeStrongSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result = InterlockedCompareExchange64((volatile long long *)ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#define cuosAtomicCompareExchangeStrongAcqRel64 cuosAtomicCompareExchangeStrongSeqCst64

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

#define cuosAtomicCompareExchangeStrongRelaxed64 cuosAtomicCompareExchangeStrongSeqCst64

#else 

static long long cuosAtomicCompareExchangeStrongRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    unsigned long long _expected = *expected;
    unsigned long long result = InterlockedCompareExchangeNoFence64((volatile long long *)ptr, desired, _expected);
    if (result == _expected) {
        return 1;
    }
    else {
        *expected = result;
        return 0;
    }
}

#endif 

#if 0
static int cuosAtomicCompareExchangeStrongSeqCst32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    return InterlockedCompareExchange(ptr, desired, *expected) == *expected;
}

static int cuosAtomicCompareExchangeStrongAcqRel32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    return InterlockedCompareExchange(ptr, desired, *expected) == *expected;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static int cuosAtomicCompareExchangeStrongRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    return InterlockedCompareExchange(ptr, desired, *expected) == *expected;
}

#else 

static int cuosAtomicCompareExchangeStrongRelaxed32(volatile unsigned int *ptr, const unsigned int desired, unsigned int *expected)
{
    return InterlockedCompareExchangeNoFence(ptr, desired, *expected) == *expected;
}

#endif 

static int cuosAtomicCompareExchangeStrongSeqCst64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    return InterlockedCompareExchange64((volatile long long *)ptr, desired, *expected) == *expected;
}

static int cuosAtomicCompareExchangeStrongAcqRel64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    return InterlockedCompareExchange64((volatile long long *)ptr, desired, *expected) == *expected;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static int cuosAtomicCompareExchangeStrongRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    return InterlockedCompareExchange64((volatile long long *)ptr, desired, *expected) == *expected;
}

#else 

static int cuosAtomicCompareExchangeStrongRelaxed64(volatile unsigned long long *ptr, const unsigned long long desired, unsigned long long *expected)
{
    return InterlockedCompareExchangeNoFence64((volatile long long *)ptr, desired, *expected) == *expected;
}

#endif 
#endif




static unsigned int cuosAtomicFetchAndIncrementSeqCst32(volatile unsigned int *ptr)
{
    return InterlockedIncrement((volatile long *)ptr) - 1;
}

static unsigned int cuosAtomicFetchAndIncrementAcqRel32(volatile unsigned int *ptr)
{
    return InterlockedIncrement((volatile long *)ptr) - 1;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned int cuosAtomicFetchAndIncrementRelaxed32(volatile unsigned int *ptr)
{
    return InterlockedIncrement((volatile long *)ptr) - 1;
}

#else 

static unsigned int cuosAtomicFetchAndIncrementRelaxed32(volatile unsigned int *ptr)
{
    return InterlockedIncrementNoFence((volatile long *)ptr) - 1;
}

#endif 

static unsigned long long cuosAtomicFetchAndIncrementSeqCst64(volatile unsigned long long *ptr)
{
    return InterlockedIncrement64((volatile long long *)ptr) - 1ULL;
}

static unsigned long long cuosAtomicFetchAndIncrementAcqRel64(volatile unsigned long long *ptr)
{
    return InterlockedIncrement64((volatile long long *)ptr) - 1ULL;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned long long cuosAtomicFetchAndIncrementRelaxed64(volatile unsigned long long *ptr)
{
    return InterlockedIncrement64((volatile long long *)ptr) - 1ULL;
}

#else 

static unsigned long long cuosAtomicFetchAndIncrementRelaxed64(volatile unsigned long long *ptr)
{
    return InterlockedIncrementNoFence64((volatile long long *)ptr) - 1ULL;
}

#endif 




static unsigned int cuosAtomicFetchAndDecrementSeqCst32(volatile unsigned int *ptr)
{
    return InterlockedDecrement((volatile long *)ptr) + 1;
}

static unsigned int cuosAtomicFetchAndDecrementAcqRel32(volatile unsigned int *ptr)
{
    return InterlockedDecrement((volatile long *)ptr) + 1;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned int cuosAtomicFetchAndDecrementRelaxed32(volatile unsigned int *ptr)
{
    return InterlockedDecrement((volatile long *)ptr) + 1;
}

#else 

static unsigned int cuosAtomicFetchAndDecrementRelaxed32(volatile unsigned int *ptr)
{
    return InterlockedDecrementNoFence((volatile long *)ptr) + 1;
}

#endif 

static unsigned long long cuosAtomicFetchAndDecrementSeqCst64(volatile unsigned long long *ptr)
{
    return InterlockedDecrement64((volatile long long *)ptr) + 1ULL;
}

static unsigned long long cuosAtomicFetchAndDecrementAcqRel64(volatile unsigned long long *ptr)
{
    return InterlockedDecrement64((volatile long long *)ptr) + 1ULL;
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned long long cuosAtomicFetchAndDecrementRelaxed64(volatile unsigned long long *ptr)
{
    return InterlockedDecrement64((volatile long long *)ptr) + 1ULL;
}

#else 

static unsigned long long cuosAtomicFetchAndDecrementRelaxed64(volatile unsigned long long *ptr)
{
    return InterlockedDecrementNoFence64((volatile long long *)ptr) + 1ULL;
}

#endif 




#if defined(_M_IX86) 

static unsigned int cuosAtomicFetchAndOrSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedOr((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndOrAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedOr((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndOrRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedOr((volatile long *)ptr, val);
}

#else 

static unsigned int cuosAtomicFetchAndOrSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedOr((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndOrAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedOr((volatile long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned int cuosAtomicFetchAndOrRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedOr((volatile long *)ptr, val);
}

#else 

static unsigned int cuosAtomicFetchAndOrRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedOrNoFence((volatile long *)ptr, val);
}

#endif 
#endif 

static unsigned long long cuosAtomicFetchAndOrSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedOr64((volatile long long *)ptr, val);
}

static unsigned long long cuosAtomicFetchAndOrAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedOr64((volatile long long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned long long cuosAtomicFetchAndOrRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedOr64((volatile long long *)ptr, val);
}

#else 

static unsigned long long cuosAtomicFetchAndOrRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedOr64NoFence((volatile long long *)ptr, val);
}

#endif 




#if defined(_M_IX86) 

static unsigned int cuosAtomicFetchAndAndSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedAnd((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndAndAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedAnd((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndAndRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return _InterlockedAnd((volatile long *)ptr, val);
}

#else 

static unsigned int cuosAtomicFetchAndAndSeqCst32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedAnd((volatile long *)ptr, val);
}

static unsigned int cuosAtomicFetchAndAndAcqRel32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedAnd((volatile long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned int cuosAtomicFetchAndAndRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedAnd((volatile long *)ptr, val);
}

#else 

static unsigned int cuosAtomicFetchAndAndRelaxed32(volatile unsigned int *ptr, const unsigned int val)
{
    return InterlockedAndNoFence((volatile long *)ptr, val);
}

#endif 
#endif 

static unsigned long long cuosAtomicFetchAndAndSeqCst64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedAnd64((volatile long long *)ptr, val);
}

static unsigned long long cuosAtomicFetchAndAndAcqRel64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedAnd64((volatile long long *)ptr, val);
}

#if _WIN32_WINNT < _WIN32_WINNT_WIN8 

static unsigned long long cuosAtomicFetchAndAndRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedAnd64((volatile long long *)ptr, val);
}

#else 

static unsigned long long cuosAtomicFetchAndAndRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    return InterlockedAnd64NoFence((volatile long long *)ptr, val);
}

#endif 



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

#if defined(_WIN64)
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

#endif 





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

#if defined(_WIN64)

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
    (void)cuosAtomicExchangeSeqCst64(ptr, val);
}

static void cuosAtomicWriteRelease64(volatile unsigned long long *ptr, const unsigned long long val)
{
    (void)cuosAtomicExchangeAcqRel64(ptr, val);
}

static void cuosAtomicWriteRelaxed64(volatile unsigned long long *ptr, const unsigned long long val)
{
    (void)cuosAtomicExchangeRelaxed64(ptr, val);
}

#endif 

#endif 

typedef struct
{
    
    int unused;
} CUOSserverSocket;

typedef struct
{
    
    int unused;
} CUOSsocket;

typedef struct
{
    
    int unused;
} CUOSsocketMsg;

struct CUOSpipe_st
{
    
    int unused;
};




#define CUOS_GL_LIBRARY_NAME                  "opengl32.dll"


#define CUOS_GL_GET_PROC_ADDRESS_FUNC_NAME    "wglGetProcAddress"

typedef void (WINAPI * CUOSglProcFn)(void);
typedef CUOSglProcFn (WINAPI *CUOSglGetProcAddressFn)(LPCSTR);


#define CUOS_GL_GET_CURRENT_CONTEXT_FUNC_NAME "wglGetCurrentContext"

typedef void * (WINAPI *CUOSglGetCurrentContextFn)(void);

#define cuosThreadIdPrintFormat "%lu"
#define cuosThreadIdPrintArguments(tid) tid


#if defined(CUOS_WIN_VISTA_PLUS)
#define cuosIsWindowsXp() 0
#define cuosIsWindowsVistaPlus() 1
#else
int cuosIsWindowsXp(void);
int cuosIsWindowsVistaPlus(void);
#endif

int cuosIsWindows7Plus(void);
int cuosIsWindows8Plus(void);
int cuosIsWindows8Point1Plus(void);
int cuosIsWindows10Plus(void);
int cuosIsWindows10RS2Plus(void);
int cuosIsWindows10RS4Plus(void);

#define cuosThreadCreateWithName(thread, startFunc, userData, name) (cuosThreadCreate(thread, startFunc, userData))

#if defined(__cplusplus)
} 
#endif

#endif 

