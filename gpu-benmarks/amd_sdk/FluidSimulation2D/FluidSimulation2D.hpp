


#ifndef FLUID_SIMULATION2D_H_
#define FLUID_SIMULATION2D_H_

#if defined(__APPLE__) || defined(__MACOSX)
#include <OpenCL/cl.h>
#else
#include <CL/cl.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define GROUP_SIZE  256
#define LBWIDTH     256
#define LBHEIGHT    256

int winwidth = LBWIDTH;
int winheight = LBHEIGHT;




class FluidSimulation2D
{
        cl_double setupTime;                        
        cl_double kernelTime;                       

        size_t maxWorkGroupSize;                    
        cl_uint maxDimensions;                      
        size_t* maxWorkItemSizes;                   
        cl_ulong totalLocalMemory;                  
        cl_ulong usedLocalMemory;                   

        int dims[2];                                

        
        cl_double *rho;                              
        cl_double2 *u;                               
        cl_double *h_if0, *h_if1234, *h_if5678;      
        cl_double *h_of0, *h_of1234, *h_of5678;      

        cl_double *v_ef0, *v_ef1234,
                  *v_ef5678;      
        cl_double *v_of0, *v_of1234,
                  *v_of5678;      

        cl_bool *h_type;                            
        cl_double *h_weight;                         
        cl_double8 dirX, dirY;                       

        
        cl_mem d_if0, d_if1234, d_if5678;           
        cl_mem d_of0, d_of1234, d_of5678;           
        cl_mem type;                                
        cl_mem weight;                              
        cl_mem velocity;                            

        
        cl_context          context;
        cl_device_id        *devices;
        cl_command_queue    commandQueue;
        cl_program program;
        cl_kernel  kernel;

        
        size_t groupSize;                               
        int iterations;

        cl_bool reqdExtSupport;
        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        void reset();
        cl_bool isBoundary(int x, int y);
        bool isFluid(int x, int y);
        cl_double2 getVelocity(int x, int y);
        void setSite(int x, int y, bool cellType, double u[2]);
        void setUOutput(int x, int y, double u[2]);

        
        void collide(int x, int y);
        void streamToNeighbors(int x, int y);

        
        FluidSimulation2D()
            :
            setupTime(0),
            kernelTime(0),

            devices(NULL),
            maxWorkItemSizes(NULL),
            groupSize(GROUP_SIZE),
            iterations(1),
            reqdExtSupport(true)
        {
            dims[0] = LBWIDTH;
            dims[1] = LBHEIGHT;
            rho = NULL;
            u = NULL;
            h_if0 = NULL;
            h_if1234 = NULL;
            h_if1234 = NULL;
            h_of0 = NULL;
            h_of1234 = NULL;
            h_of1234 = NULL;
            v_ef0 = NULL;
            v_ef1234 = NULL;
            v_ef5678 = NULL;
            v_of0 = NULL;
            v_of1234 = NULL;
            v_of5678 = NULL;
            h_type = NULL;
            h_weight = NULL;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        ~FluidSimulation2D();

        
        int setupFluidSimulation2D();

        
        int genBinaryImage();

        
        int setupCL();

        
        int setupCLKernels();

        
        int runCLKernels();

        
        void CPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

};

#endif 
