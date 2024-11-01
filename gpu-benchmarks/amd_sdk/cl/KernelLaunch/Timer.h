

#ifndef _TIMER_H_
#define _TIMER_H_

#ifdef _WIN32

#if defined(__MINGW64__) || defined(__MINGW32__)
typedef long long i64;
#else
typedef __int64 i64;
#endif
#else

typedef long long i64;
#endif



class CPerfCounter {

public:
    
    CPerfCounter();
    
    ~CPerfCounter();
    
    void Start(void);
    
    void Stop(void);
    
    void Reset(void);
    
    double GetElapsedTime(void);

private:

    i64 _freq;
    i64 _clocks;
    i64 _start;
};

#endif 

