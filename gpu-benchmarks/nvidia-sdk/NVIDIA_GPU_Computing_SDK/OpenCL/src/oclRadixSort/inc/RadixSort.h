
#ifndef _RADIXSORT_H_
#define _RADIXSORT_H_

#if defined (__APPLE__) || defined(MACOSX)
    #include <OpenCL/opencl.h>
#else
    #include <CL/opencl.h>
#endif 
#include "Scan.h"

class RadixSort
{
public:
	RadixSort(cl_context GPUContext,
		      cl_command_queue CommandQue,
			  unsigned int maxElements, 
			  const char *path,
			  const int ctaSize,
			  bool keysOnly);
	RadixSort() {}
	~RadixSort();

	void sort(cl_mem d_keys,
			  unsigned int *values, 
			  unsigned int  numElements,
			  unsigned int  keyBits);

private:
	cl_context cxGPUContext;             
    cl_command_queue cqCommandQueue;     
    cl_program cpProgram;                
	cl_mem d_tempKeys;                   
	cl_mem mCounters;                    
	cl_mem mCountersSum;                 
	cl_mem mBlockOffsets;                
    cl_kernel ckRadixSortBlocksKeysOnly; 
	cl_kernel ckFindRadixOffsets;
	cl_kernel ckScanNaive;
	cl_kernel ckReorderDataKeysOnly;

	int CTA_SIZE; 
    static const unsigned int WARP_SIZE = 32;
	static const unsigned int bitStep = 4;

	unsigned int  mNumElements;     
    unsigned int *mTempValues;      
         
	Scan scan;

	void radixSortKeysOnly(cl_mem d_keys, unsigned int numElements, unsigned int keyBits);
	void radixSortStepKeysOnly(cl_mem d_keys, unsigned int nbits, unsigned int startbit, unsigned int numElements);
	void radixSortBlocksKeysOnlyOCL(cl_mem d_keys, unsigned int nbits, unsigned int startbit, unsigned int numElements);
	void findRadixOffsetsOCL(unsigned int startbit, unsigned int numElements);
	void scanNaiveOCL(unsigned int numElements);
	void reorderDataKeysOnlyOCL(cl_mem d_keys, unsigned int startbit, unsigned int numElements);
};
#endif