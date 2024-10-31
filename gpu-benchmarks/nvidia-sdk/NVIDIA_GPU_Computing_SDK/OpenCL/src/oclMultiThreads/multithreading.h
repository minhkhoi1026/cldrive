

#ifndef MULTITHREADING_H
#define MULTITHREADING_H




#if _WIN32
    
    #include <windows.h>

    typedef HANDLE CUTThread;
    typedef unsigned (WINAPI *CUT_THREADROUTINE)(void *);

	struct CUTBarrier {
		CRITICAL_SECTION criticalSection;
		HANDLE barrierEvent;
		int releaseCount;
		int count;
	};

    #define CUT_THREADPROC unsigned WINAPI
    #define  CUT_THREADEND return 0

#else
    
    #include <pthread.h>

    typedef pthread_t CUTThread;
    typedef void *(*CUT_THREADROUTINE)(void *);

    #define CUT_THREADPROC void*
    #define  CUT_THREADEND 

	struct CUTBarrier {
		pthread_mutex_t mutex;
		pthread_cond_t conditionVariable;
		int releaseCount;
		int count;
	};

#endif


#ifdef __cplusplus
    extern "C" {
#endif


CUTThread cutStartThread(CUT_THREADROUTINE, void *data);


void cutEndThread(CUTThread thread);


void cutDestroyThread(CUTThread thread);


void cutWaitForThreads(const CUTThread *threads, int num);


CUTBarrier cutCreateBarrier(int releaseCount);


void cutIncrementBarrier(CUTBarrier *barrier);


void cutWaitForBarrier(CUTBarrier *barrier);


void cutDestroyBarrier(CUTBarrier *barrier);


#ifdef __cplusplus
} 
#endif

#endif 
