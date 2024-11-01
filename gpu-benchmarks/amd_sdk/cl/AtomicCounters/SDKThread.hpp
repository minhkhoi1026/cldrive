
#ifndef _SDK_THREAD_H_
#define _SDK_THREAD_H

#ifdef _WIN32
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0501
#endif


#include "windows.h"
#include <deque>
#include "assert.h"
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <process.h>
#endif
#define EXPORT __declspec(dllexport)

#else
#include "pthread.h"
#define EXPORT
#endif


#if defined(__INTEL_COMPILER)
#pragma warning(disable : 810)
#endif


#ifdef PRINT_COND_VAR_ERROR_MSG
#define PRINT_ERROR_MSG(errorcode, msg) \
    if(errorcode != 0) \
        printf("%s \n", msg)
#else
#define PRINT_ERROR_MSG(errorcode, msg)
#endif 


namespace appsdk
{

typedef void* (*threadFunc)(void*);


typedef struct __argsToThreadFunc
{
    threadFunc func;
    void* data;

} argsToThreadFunc;






class EXPORT ThreadLock
{
    public:

        
        ThreadLock()
        {
#ifdef _WIN32
            InitializeCriticalSection(&_cs);
#else
            pthread_mutex_init(&_lock, NULL);
#endif
        }

        
        ~ThreadLock()
        {
#ifdef _WIN32
            DeleteCriticalSection(&_cs);
#else
            pthread_mutex_destroy(&_lock);
#endif
        }

        
        bool isLocked()
        {
#ifdef _WIN32
            return (_cs.LockCount != ~0x0);
#else
            if(pthread_mutex_trylock(&_lock) != 0)
            {
                return true;
            }
            pthread_mutex_unlock(&_lock);
            return false;
#endif
        }

        
        void lock()
        {
#ifdef _WIN32
            EnterCriticalSection(&_cs);
#else
            pthread_mutex_lock(&_lock);
#endif
        }

        
        bool tryLock()
        {
#ifdef _WIN32
            return (TryEnterCriticalSection(&_cs) != 0);
#else
            return !((bool)pthread_mutex_trylock(&_lock));
#endif
        }

        
        void unlock()
        {
#ifdef _WIN32
            LeaveCriticalSection(&_cs);
#else
            pthread_mutex_unlock(&_lock);
#endif
        }

    private:

        

        
#ifdef _WIN32
        CRITICAL_SECTION _cs;
#else
        pthread_mutex_t _lock;
#endif
};




class CondVarImpl;
class EXPORT CondVar
{
    public:
        
        CondVar();

        ~CondVar();

        
        bool init(unsigned int maxThreadCount);

        
        bool destroy();

        
        void syncThreads();


    private:

        
        CondVarImpl* _condVarImpl;

};
#ifdef _WIN32
unsigned _stdcall win32ThreadFunc(void* args);
#endif

class EXPORT SDKThread
{
    public:
        
        SDKThread() : _tid(0), _data(0)
        {
        }

        ~SDKThread()
        {
#ifdef _WIN32
            if(_tid)
            {
                CloseHandle(_tid);
                _tid = 0;
            }
#endif
        }

        
        bool create(threadFunc func, void* arg)
        {
            
            _data = arg;
#ifdef _WIN32
            
            
            
            argsToThreadFunc *args =  new argsToThreadFunc;
            args->func = func;
            args->data = this;
            _tid = (HANDLE)_beginthreadex(NULL, 0, win32ThreadFunc, args, 0, NULL);
            if(_tid == 0)
            {
                return false;
            }
#else
            
            int retVal = pthread_create(&_tid, NULL, func, arg);
            if(retVal != 0)
            {
                return false;
            }
#endif
            return true;
        }

        
        bool join()
        {
            if(_tid)
            {
#ifdef _WIN32
                DWORD rc = WaitForSingleObject(_tid, INFINITE);
                CloseHandle(_tid);
                if(rc == WAIT_FAILED)
                {
                    printf("Bad call to function(invalid handle?)\n");
                }
#else
                int rc = pthread_join(_tid, NULL);
#endif
                _tid = 0;
                if(rc != 0)
                {
                    return false;
                }
            }
            return true;
        }

        
        void* getData()
        {
            return _data;
        }

        
        unsigned int getID()
        {
#if defined(__MINGW32__) && defined(__MINGW64_VERSION_MAJOR)
            
            return (unsigned int)(long long)_tid;
#else
            return (unsigned int)_tid;
#endif 
        }

    private:

        

#ifdef _WIN32
        
        HANDLE _tid;
#else
        pthread_t _tid;
#endif

        void *_data;

};

#ifdef _WIN32


unsigned _stdcall win32ThreadFunc(void* args)
{
    argsToThreadFunc* ptr = (argsToThreadFunc*) args;
    SDKThread *obj = (SDKThread *) ptr->data;
    ptr->func(obj->getData());
    delete args;
    return 0;
}
#endif



class CondVarImpl
{
    public:
        
        CondVarImpl() : _count(0xFFFFFFFF), _maxThreads(0xFFFFFFFF)
        {
        }


        
        ~CondVarImpl()
        {
        }

        
        bool init(unsigned int maxThreadCount)
        {
            int rc = 0;
            
            _count = 0xFFFFFFFF;
            _maxThreads = maxThreadCount;
#ifdef _WIN32
            _nLockCount = 0;
            
            
            InitializeCriticalSection(&_critsecWaitSetProtection);
            
            
            InitializeCriticalSection(&_condVarLock);
#else
            pthread_mutex_init(&_condVarLock, NULL);
            PRINT_ERROR_MSG(rc, "Failed to initialize condition variable lock");
            rc = pthread_cond_init(&_condVar, NULL);
            PRINT_ERROR_MSG(rc, "Failed to Initialize condition variable");
#endif
            if(rc != 0)
            {
                return false;
            }
            return true;
        }

        
        bool destroy()
        {
            int rc = 0;
#ifdef _WIN32
            
            
            DeleteCriticalSection(&_critsecWaitSetProtection);
            DeleteCriticalSection(&_condVarLock);
            
            
            assert( _deqWaitSet.empty() );
#else
            
            pthread_mutex_destroy(&_condVarLock);
            PRINT_ERROR_MSG(rc, "Failed to destroy condition variable lock");
            
            rc = pthread_cond_destroy(&_condVar);
            PRINT_ERROR_MSG(rc, "Failed to destroy condition variable");
#endif
            if(rc != 0)
            {
                return false;
            }
            return true;
        }

        
        void syncThreads()
        {
            
            beginSynchronized();
            int rc = 0;
            
            if(_count == 0xFFFFFFFF)
            {
                _count = 0;
            }
            else
            {
                _count++;
            }
            if(_count >= _maxThreads - 1)
            {
                
                _count = 0xFFFFFFFF;
                
#ifdef _WIN32
                rc = broadcast();
                if(rc == 0)
                {
                    printf("Problem while calling broadcast\n");
                }
#else
                rc = pthread_cond_broadcast(&_condVar);
                PRINT_ERROR_MSG(rc, "Problem while calling pthread_cond_broadcast()");
#endif 
            }
            else
            {
                
#ifdef _WIN32
                wait();
#else
                if(_count < _maxThreads - 1)
                {
                    rc = pthread_cond_wait(&_condVar, &_condVarLock);
                    PRINT_ERROR_MSG(rc, "Problem while calling pthread_cond_wait()");
                }
#endif 
            }
            
            endSynchronized();
        }


    private:

        
        void beginSynchronized()
        {
#ifdef _WIN32
            
            EnterCriticalSection(&_condVarLock);
            
            ++_nLockCount;
#else
            pthread_mutex_lock(&_condVarLock);
#endif 
        }

        
        int endSynchronized()
        {
#ifdef _WIN32
            if(! _lockHeldByCallingThread())
            {
                ::SetLastError(ERROR_INVALID_FUNCTION); 
                return 0;
            }
            
            --_nLockCount;
            
            ::LeaveCriticalSection(&_condVarLock);
#else
            pthread_mutex_unlock(&_condVarLock);
#endif 
            return 1;
        }

#ifdef _WIN32

        
        DWORD wait(DWORD dwMillisecondsTimeout = INFINITE, BOOL bAlertable = FALSE)
        {
            if(! _lockHeldByCallingThread())
            {
                ::SetLastError(ERROR_INVALID_FUNCTION); 
                return WAIT_FAILED;
            }
            
            HANDLE hWaitEvent = _push();
            if(NULL == hWaitEvent)
            {
                return WAIT_FAILED;
            }
            
            int nThisThreadsLockCount = _nLockCount;
            _nLockCount = 0;
            
            
            for(int i = 0; i < nThisThreadsLockCount; ++i)
            {
                LeaveCriticalSection(&_condVarLock);
            }
            
            
            
            
            
            
            
            
            
            
            DWORD dwWaitResult = ::WaitForSingleObjectEx(hWaitEvent, dwMillisecondsTimeout,
                                 bAlertable);
            
            
            DWORD dwLastError = 0;
            if(WAIT_FAILED == dwWaitResult)
            {
                dwLastError = ::GetLastError();
            }
            
            
            for(int j = 0; j < nThisThreadsLockCount; ++j)
            {
                EnterCriticalSection(&_condVarLock);
            }
            
            _nLockCount = nThisThreadsLockCount;
            
            if(! CloseHandle(hWaitEvent))
            {
                return WAIT_FAILED;
            }
            if(WAIT_FAILED == dwWaitResult)
            {
                ::SetLastError(dwLastError);
            }
            return dwWaitResult;
        }

        
        BOOL broadcast()
        {
            
            
            EnterCriticalSection(&_critsecWaitSetProtection);
            std::deque<HANDLE>::const_iterator it_run = _deqWaitSet.begin();
            std::deque<HANDLE>::const_iterator it_end = _deqWaitSet.end();
            for( ; it_run < it_end; ++it_run)
            {
                if(! SetEvent(*it_run))
                {
                    return FALSE;
                }
            }
            _deqWaitSet.clear();
            LeaveCriticalSection(&_critsecWaitSetProtection);
            return TRUE;
        }

        
        HANDLE _push()
        {
            
            HANDLE hWaitEvent = ::CreateEvent(NULL, 
                                              FALSE, 
                                              FALSE, 
                                              NULL); 
            if(NULL == hWaitEvent)
            {
                return NULL;
            }
            
            EnterCriticalSection(&_critsecWaitSetProtection);
            _deqWaitSet.push_back(hWaitEvent);
            LeaveCriticalSection(&_critsecWaitSetProtection);
            return hWaitEvent;
        }

        
        HANDLE _pop()
        {
            
            EnterCriticalSection(&_critsecWaitSetProtection);
            HANDLE hWaitEvent = NULL;
            if(0 != _deqWaitSet.size())
            {
                hWaitEvent = _deqWaitSet.front();
                _deqWaitSet.pop_front();
            }
            LeaveCriticalSection(&_critsecWaitSetProtection);
            return hWaitEvent;
        }

        
        BOOL _lockHeldByCallingThread()
        {
            BOOL bTryLockResult = TryEnterCriticalSection(&_condVarLock);
            
            if(!bTryLockResult)
            {
                return FALSE;
            }
            
            if(0 == _nLockCount)
            {
                assert(bTryLockResult);
                LeaveCriticalSection(&_condVarLock);
                return FALSE;
            }
            
            
            assert(bTryLockResult && 0 < _nLockCount);
            LeaveCriticalSection(&_condVarLock);
            return TRUE;
        }


        
        std::deque<HANDLE> _deqWaitSet;

        
        CRITICAL_SECTION _critsecWaitSetProtection;

        
        CRITICAL_SECTION _condVarLock;

        
        int _nLockCount;

#else

        
        pthread_cond_t _condVar;

        
        pthread_mutex_t _condVarLock;

#endif

        
        unsigned int _maxThreads;

        
        unsigned int _count;

};

        CondVar::CondVar()
        {
            _condVarImpl = new CondVarImpl();
        }
        CondVar::~CondVar()
        {
            delete _condVarImpl;
        }

        
        bool CondVar::init(unsigned int maxThreadCount)
        {
            return _condVarImpl->init(maxThreadCount);
        }

        
        bool CondVar::destroy()
        {
            return _condVarImpl->destroy();
        }

        
        void CondVar::syncThreads()
        {
            _condVarImpl->syncThreads();
        }


}

#endif 
