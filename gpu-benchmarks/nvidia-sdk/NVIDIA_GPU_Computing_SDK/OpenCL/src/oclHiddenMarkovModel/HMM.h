

#ifndef _HMM_H_
#define _HMM_H_

#include <CL/cl.h>
#define USE_EVENT

class HMM
{
public:
    HMM(cl_context GPUContext,
        cl_command_queue CommandQue,
        float *initProb,
        float *mtState,
        float *mtEmit,
        int numState,
        int numEmit,
		int numObs,
        const char *path,
		int workgroupSize);
    HMM() {};
    ~HMM();

    size_t ViterbiSearch(cl_mem vProb, 
                       cl_mem vPath, 
                       int *obs);
	double getKTime() {return kTime;}

private:
    cl_context cxGPUContext;             
    cl_command_queue cqCommandQue;       
    cl_program cpProgram;                
    cl_kernel ckViterbiOneStep;
    cl_kernel ckViterbiPath;
    cl_mem d_maxProbNew;
    cl_mem d_maxProbOld;
    cl_mem d_mtState;
    cl_mem d_mtEmit;
    cl_mem d_path;
	double kTime;
    int nState;
    int nEmit;
	int nObs;
    size_t ViterbiOneStep(const int &obs, const int &iObs);
    void ViterbiPath(cl_mem vProb, cl_mem vPath);
    double tKernel;
    bool smallBlock;
	int wgSize;
};

#endif
