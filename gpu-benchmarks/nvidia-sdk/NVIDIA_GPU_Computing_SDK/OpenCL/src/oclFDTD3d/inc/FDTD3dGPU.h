

#ifndef _FDTD3DGPU_H_
#define _FDTD3DGPU_H_

#include <cstddef>
#if defined(_WIN32) && defined(_MSC_VER)
typedef unsigned __int64 memsize_t;
#else
#include <stdint.h>
typedef uint64_t memsize_t;
#endif






#define k_localWorkX    32
#define k_localWorkY    8
#define k_localWorkMin  128
#define k_localWorkMax  1024


extern const char* clSourceFile;

bool getTargetDeviceGlobalMemSize(memsize_t *result, const int argc, const char **argv);
bool fdtdGPU(float *output, const float *input, const float *coeff, const int dimx, const int dimy, const int dimz, const int radius, const int timesteps, const int argc, const char **argv);

#endif
