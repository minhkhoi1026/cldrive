

#ifndef _HOST_H_
#define _HOST_H_

#include <stddef.h>

#ifdef _WIN32
#define MEM_MULTICORE
#define MAXWORKERS 32
#else
#define MAXWORKERS 1
#endif

extern int nWorkers;

bool readVerifyMemCPU( void *, unsigned char, size_t );
bool readVerifyMemCPU_MT( void *, unsigned char, size_t );
void memset_MT( void *, unsigned char, size_t );
void memcpy_MT( void *, void *, size_t );
void writeMemCPU( void *, unsigned char, size_t );
bool readVerifyMemSSE( void *, unsigned char, size_t );
void writeMemSSE ( void *, unsigned char, size_t );

bool readmem2DPitch( void *, unsigned char, size_t, int );
void memset2DPitch( void *, unsigned char, size_t, size_t, size_t );

void runon( unsigned int );
void stridePagesCPU( void *, size_t );
void assessHostMemPerf( void *, void *, size_t );

void benchThreads();
void launchThreads();
void shutdownThreads();

#endif 
