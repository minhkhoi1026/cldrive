



#include <oclUtils.h>






extern "C" void BlackScholesCPU(
    float *h_Call, 
    float *h_Put,  
    float *h_S,    
    float *h_X,    
    float *h_T,    
    float R,       
    float V,       
    unsigned int optionCount
);





extern "C" void initBlackScholes(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);

extern "C" void closeBlackScholes(void);

extern "C" void BlackScholes(
    cl_command_queue cqCommandQueue,
    cl_mem d_Call, 
    cl_mem d_Put,  
    cl_mem d_S,    
    cl_mem d_X,    
    cl_mem d_T,    
    cl_float R,    
    cl_float V,    
    cl_uint optionCount
);
