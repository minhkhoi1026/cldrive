
 
 

#ifndef _SWEEP_SMALL_SYSTEMS_
#define _SWEEP_SMALL_SYSTEMS_

#include "common.h"

#define TRANSPOSE_BLOCK_DIM		16

const int sweepNumKernels = 4;

const char *sweepKernelNames[sweepNumKernels] = { 
	"sweep_small_systems_local_kernel",			
	"sweep_small_systems_global_kernel",		
	"sweep_small_systems_global_vec4_kernel",	
	"transpose",							
};  

cl_kernel sweepKernel[MAX_GPU_COUNT];
cl_kernel reorderKernel[MAX_GPU_COUNT];

double runReorderKernel(int devCount, cl_mem *dev_a, cl_mem *dev_t, int *width, int *height, double *kernelTime)
{
	size_t szGlobalWorkSize[MAX_GPU_COUNT][2];
    size_t szLocalWorkSize[MAX_GPU_COUNT][2];
	cl_event GPUExecution[MAX_GPU_COUNT];
	cl_int errcode;
	
	for (int i = 0; i < devCount; i++)
	{
		
		szLocalWorkSize[i][0] = TRANSPOSE_BLOCK_DIM;
		szLocalWorkSize[i][1] = TRANSPOSE_BLOCK_DIM;
		szGlobalWorkSize[i][0] = shrRoundUp(TRANSPOSE_BLOCK_DIM, width[i]);
		szGlobalWorkSize[i][1] = shrRoundUp(TRANSPOSE_BLOCK_DIM, height[i]);

		
		errcode  = clSetKernelArg(reorderKernel[i], 0, sizeof(cl_mem), (void *) &dev_t[i]);
		errcode |= clSetKernelArg(reorderKernel[i], 1, sizeof(cl_mem), (void *) &dev_a[i]);
		errcode |= clSetKernelArg(reorderKernel[i], 2, sizeof(int), &width[i]);
		errcode |= clSetKernelArg(reorderKernel[i], 3, sizeof(int), &height[i]);
		errcode |= clSetKernelArg(reorderKernel[i], 4, TRANSPOSE_BLOCK_DIM * (TRANSPOSE_BLOCK_DIM+1) * sizeof(float), NULL);
		oclCheckError(errcode, CL_SUCCESS);

		errcode = clEnqueueNDRangeKernel(cqCommandQue[i], reorderKernel[i], 2, NULL, szGlobalWorkSize[i], szLocalWorkSize[i], 0, NULL, &GPUExecution[i]);
		clFlush(cqCommandQue[i]);
		oclCheckError(errcode, CL_SUCCESS);
	}
	clWaitForEvents(devCount, GPUExecution);

	
	double sum_time = 0.0;
	for (int iCycles = 0; iCycles < BENCH_ITERATIONS; iCycles++)
	{
		shrDeltaT(0);
		for (int i = 0; i < devCount; i++)
		{
			errcode = clEnqueueNDRangeKernel(cqCommandQue[i], reorderKernel[i], 2, NULL, szGlobalWorkSize[i], szLocalWorkSize[i], 0, NULL, &GPUExecution[i]);
			clFlush(cqCommandQue[i]);
			oclCheckError(errcode, CL_SUCCESS);
		}
		clWaitForEvents(devCount, GPUExecution);
		sum_time += shrDeltaT(0);
	}
	double time = sum_time / BENCH_ITERATIONS;

#ifdef GPU_PROFILING
	for (int i = 0; i < devCount; i++)
	{
		kernelTime[i] += executionTime(GPUExecution[i]);
		clReleaseEvent(GPUExecution[i]);
	}
#endif

	return time;
}

double runSweepKernel(int devCount, cl_mem *dev_a, cl_mem *dev_b, cl_mem *dev_c, cl_mem *dev_d, cl_mem *dev_x, cl_mem *dev_t, cl_mem *dev_w, int system_size, int *workSize)
{
	size_t szGlobalWorkSize[MAX_GPU_COUNT];
    size_t szLocalWorkSize[MAX_GPU_COUNT];
	cl_event GPUExecution[MAX_GPU_COUNT];
	cl_int errcode;

	for (int i = 0; i < devCount; i++)
	{
		int num_systems = workSize[i];

		
		if (useVec4) szLocalWorkSize[i] = SWEEP_BLOCK_SIZE / 4;
			else szLocalWorkSize[i] = SWEEP_BLOCK_SIZE;
		szGlobalWorkSize[i] = shrRoundUp(SWEEP_BLOCK_SIZE, num_systems);
	
		
		errcode  = clSetKernelArg(sweepKernel[i], 0, sizeof(cl_mem), (void *) &dev_a[i]);
		errcode |= clSetKernelArg(sweepKernel[i], 1, sizeof(cl_mem), (void *) &dev_b[i]);
		errcode |= clSetKernelArg(sweepKernel[i], 2, sizeof(cl_mem), (void *) &dev_c[i]);
		errcode |= clSetKernelArg(sweepKernel[i], 3, sizeof(cl_mem), (void *) &dev_d[i]);
		errcode |= clSetKernelArg(sweepKernel[i], 4, sizeof(cl_mem), (void *) &dev_x[i]);
		errcode |= clSetKernelArg(sweepKernel[i], 5, sizeof(int), &num_systems);
		if (!useLmem) errcode |= clSetKernelArg(sweepKernel[i], 6, sizeof(cl_mem), (void *) &dev_w[i]);
		oclCheckError(errcode, CL_SUCCESS);

		
		errcode = clEnqueueNDRangeKernel(cqCommandQue[i], sweepKernel[i], 1, NULL, &szGlobalWorkSize[i], &szLocalWorkSize[i], 0, NULL, &GPUExecution[i]);
		clFlush(cqCommandQue[i]);
		oclCheckError(errcode, CL_SUCCESS);
	}
	clWaitForEvents(devCount, GPUExecution);

	shrLog("  looping %i times..\n", BENCH_ITERATIONS);	

	
	double sum_time = 0.0;
	for (int iCycles = 0; iCycles < BENCH_ITERATIONS; iCycles++)
	{
		shrDeltaT(0);
		for (int i = 0; i < devCount; i++)
		{
			errcode = clEnqueueNDRangeKernel(cqCommandQue[i], sweepKernel[i], 1, NULL, &szGlobalWorkSize[i], &szLocalWorkSize[i], 0, NULL, &GPUExecution[i]);
			clFlush(cqCommandQue[i]);
			oclCheckError(errcode, CL_SUCCESS);
		}
		clWaitForEvents(devCount, GPUExecution);
		sum_time += shrDeltaT(0);
	}
	double time = sum_time / BENCH_ITERATIONS;

#ifdef GPU_PROFILING
	
	for (int i = 0; i < devCount; i++)
	{
		shrLog("  GPU %d time =  %.5f s\n", i, executionTime(GPUExecution[i]));
		clReleaseEvent(GPUExecution[i]);
	}
#endif
	
	return time;
}

void swap_ptrs(int devCount, cl_mem *a, cl_mem *b)
{
	cl_mem c;
	for (int i = 0; i < devCount; i++)
	{
		c = a[i];
		a[i] = b[i];
		b[i] = c;
	}
}

double sweep_small_systems(int devCount, const char** argv, float *a, float *b, float *c, float *d, float *x, int system_size, int num_systems, bool reorder = false)
{
    shrLog(" %s\n", reorder ? " sweep_data_reorder_kernel" : sweepKernelNames[0]);
 
    const unsigned int mem_size = sizeof(float) * num_systems * system_size;

	cl_int errcode;

	cl_mem device_a[MAX_GPU_COUNT];
	cl_mem device_b[MAX_GPU_COUNT];
	cl_mem device_c[MAX_GPU_COUNT];
	cl_mem device_d[MAX_GPU_COUNT];
	cl_mem device_x[MAX_GPU_COUNT];
	cl_mem device_t[MAX_GPU_COUNT];		
	cl_mem device_w[MAX_GPU_COUNT];		

	int workSize[MAX_GPU_COUNT];		
	int systemSizes[MAX_GPU_COUNT];		
	int workOffset[MAX_GPU_COUNT];		

	cl_event GPUDone[MAX_GPU_COUNT];
	double reorderKernelTime[MAX_GPU_COUNT];

	
	cl_mem host_a = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, mem_size, a, NULL);
	cl_mem host_b = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, mem_size, b, NULL);
	cl_mem host_c = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, mem_size, c, NULL);
	cl_mem host_d = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, mem_size, d, NULL);

    
	workOffset[0] = 0;
	for (int i = 0; i < devCount; i++)
	{
		workSize[i] = num_systems / devCount;	
		systemSizes[i] = system_size;
		
		
		int workSizeB = workSize[i] * system_size * sizeof(float);
		int workOffsetB = workOffset[i] * system_size * sizeof(float);

		device_a[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);
		clEnqueueCopyBuffer(cqCommandQue[i], host_a, device_a[i], workOffsetB, 0, workSizeB, 0, NULL, NULL); 

		device_b[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);
		clEnqueueCopyBuffer(cqCommandQue[i], host_b, device_b[i], workOffsetB, 0, workSizeB, 0, NULL, NULL);  

		device_c[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);
		clEnqueueCopyBuffer(cqCommandQue[i], host_c, device_c[i], workOffsetB, 0, workSizeB, 0, NULL, NULL);  

		device_d[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_ONLY, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);
		clEnqueueCopyBuffer(cqCommandQue[i], host_d, device_d[i], workOffsetB, 0, workSizeB, 0, NULL, NULL);  

		device_x[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_WRITE, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);

		device_t[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_WRITE, workSizeB, NULL, &errcode);
		oclCheckError(errcode, CL_SUCCESS);

		if (!useLmem)
		{
			device_w[i] = clCreateBuffer(cxGPUContext, CL_MEM_READ_WRITE, workSizeB, NULL, &errcode);
			oclCheckError(errcode, CL_SUCCESS);
		}
		
		if (i < devCount-1) workOffset[i+1] = workOffset[i] + workSize[i];
	}

	
	clReleaseMemObject(host_a);
	clReleaseMemObject(host_b);
	clReleaseMemObject(host_c);
	clReleaseMemObject(host_d);

    
	size_t program_length;
	char *source = oclLoadProgSource(shrFindFilePath("sweep_kernels.cl", argv[0]), "", &program_length);
    oclCheckError(source != NULL, shrTRUE);

    
    cl_program cpProgram = clCreateProgramWithSource(cxGPUContext, 1, (const char **)&source, &program_length, &errcode);
    oclCheckError(errcode, CL_SUCCESS);

	
    char options[256]={0};
    #ifdef _WIN32
	    sprintf_s(options, 256, "-cl-fast-relaxed-math -D BLOCK_DIM=%d -D system_size=%d", TRANSPOSE_BLOCK_DIM, system_size);
        if (reorder) strcat_s(options, 256, " -D REORDER");
    #else
	    sprintf(options, "-cl-fast-relaxed-math -D BLOCK_DIM=%d -D system_size=%d", TRANSPOSE_BLOCK_DIM, system_size);
	    if (reorder) strcat(options, " -D REORDER");
    #endif
    
	
	errcode = clBuildProgram(cpProgram, 0, NULL, options, NULL, NULL);
	if (errcode != CL_SUCCESS)
    {
        
        oclLogBuildInfo(cpProgram, oclGetFirstDev(cxGPUContext));
        oclLogPtx(cpProgram, oclGetFirstDev(cxGPUContext), "sweep_kernels.ptx");
        shrLog("\nFAILED\n\n");
        oclCheckError(errcode, CL_SUCCESS);
    }

	
	for (int i = 0; i < devCount; i++)
	{
		int kernelIdx;
		
		if (useLmem) kernelIdx = 0;
		else if (useVec4) kernelIdx = 2;
		else kernelIdx = 1;
		
		sweepKernel[i] = clCreateKernel(cpProgram, sweepKernelNames[kernelIdx], &errcode);
        oclCheckError(errcode, CL_SUCCESS);
		reorderKernel[i] = clCreateKernel(cpProgram, sweepKernelNames[3], &errcode);
        oclCheckError(errcode, CL_SUCCESS);
		reorderKernelTime[i] = 0.0;
	}

	double reorder_time = 0.0;
	double solver_time = 0.0;

	if (reorder)
	{
		
		reorder_time += runReorderKernel(devCount, device_a, device_t, systemSizes, workSize, reorderKernelTime);
		swap_ptrs(devCount, device_a, device_t);

		reorder_time += runReorderKernel(devCount, device_b, device_t, systemSizes, workSize, reorderKernelTime);
		swap_ptrs(devCount, device_b, device_t);

		reorder_time += runReorderKernel(devCount, device_c, device_t, systemSizes, workSize, reorderKernelTime);
		swap_ptrs(devCount, device_c, device_t);

		reorder_time += runReorderKernel(devCount, device_d, device_t, systemSizes, workSize, reorderKernelTime);
		swap_ptrs(devCount, device_d, device_t);
	}

	
	solver_time = runSweepKernel(devCount, device_a, device_b, device_c, device_d, device_x, device_t, device_w, system_size, workSize);
	
	if (reorder)
	{
		
		reorder_time += runReorderKernel(devCount, device_x, device_t, workSize, systemSizes, reorderKernelTime);
		swap_ptrs(devCount, device_x, device_t);
	}

#ifdef GPU_PROFILING
	if (reorder)
	{
		
		shrLog("  reorder\n"); 
		for (int i = 0; i < devCount; i++)
        {
			shrLog("  GPU %d time = %.5f s\n", i, reorderKernelTime[i]);
        }
		shrLog("\n"); 
	}
#endif

    
	for (int i = 0; i < devCount; i++) 
	{
		int workSizeB = workSize[i] * system_size * sizeof(float);
		errcode = clEnqueueReadBuffer(cqCommandQue[i], device_x[i], CL_FALSE, 0, workSizeB, x + workOffset[i] * system_size, 0, NULL, &GPUDone[i]);
		oclCheckError(errcode, CL_SUCCESS);
	}
	clWaitForEvents(devCount, GPUDone);

    
	for (int i = 0; i < devCount; i++)
	{
		clReleaseMemObject(device_a[i]);
		clReleaseMemObject(device_b[i]);
		clReleaseMemObject(device_c[i]);
		clReleaseMemObject(device_d[i]);
		clReleaseMemObject(device_x[i]);
		clReleaseMemObject(device_t[i]);
		if (!useLmem) clReleaseMemObject(device_w[i]);
		clReleaseEvent(GPUDone[i]);
	}

	
    
    return solver_time + reorder_time;
}

#endif
