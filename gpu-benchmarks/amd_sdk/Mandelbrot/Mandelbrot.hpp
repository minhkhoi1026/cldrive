


#ifndef MANDELBROT_H_
#define MANDELBROT_H_



#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <math.h>


#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define MAX_ITER 16384
#define MIN_ITER 32
#define MAX_DEVICES 4



class Mandelbrot
{
        cl_uint
        seed;                      
        cl_double
        setupTime;                      
        cl_double
        totalKernelTime;                      
        cl_double
        totalProgramTime;                      
        cl_uint
        *verificationOutput;                     

        bool
        enableDouble;               
        bool
        enableFMA;                  
        cl_double                xpos;                      
        cl_double                ypos;                      
        cl_double               xsize;                      
        cl_double
        ysize;                      
        cl_double               xstep;                      
        cl_double               ystep;                      

        cl_double               leftx;
        cl_double               topy;
        cl_double               topy0;

        std::string          xpos_str;
        std::string          ypos_str;
        std::string         xsize_str;
        cl_int
        maxIterations;                           
        cl_context            context;                          
        cl_device_id         *devices;                          
        cl_uint
        numDevices;                          
        cl_mem           outputBuffer[MAX_DEVICES];             
        cl_command_queue commandQueue[MAX_DEVICES];             
        cl_program            program;                          
        cl_kernel       kernel_vector[MAX_DEVICES];             
        cl_int
        width;                          
        cl_int
        height;                          
        size_t    kernelWorkGroupSize;                          
        int
        iterations;                          
        cl_int                  bench;                          
        cl_int
        benched;                          
        cl_double                time;                          
        cl_device_type
        dType;                          
        size_t globalThreads;
        size_t localThreads ;
        SDKDeviceInfo
        deviceInfo;                    
        KernelWorkGroupInfo
        kernelInfo;              


        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        cl_uint *output;                                        


        
        Mandelbrot()

        {
            seed = 123;
            output = NULL;
            verificationOutput = NULL;
            xpos = 0.0;
            ypos = 0.0;
            width = 256;
            height = 256;
            xstep = (4.0/(double)width);
            ystep = (-4.0/(double)height);
            xpos_str = "";
            ypos_str = "";
            xsize_str = "";
            maxIterations = 1024;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
            bench = 0;
            benched = 0;
            enableDouble = false;
            enableFMA = false;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        int setupMandelbrot();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();


        
        void mandelbrotRefFloat(cl_uint * verificationOutput,
                                cl_float leftx,
                                cl_float topy,
                                cl_float xstep,
                                cl_float ystep,
                                cl_int maxIterations,
                                cl_int width,
                                cl_int bench);

        
        void
        mandelbrotRefDouble(
            cl_uint * verificationOutput,
            cl_double posx,
            cl_double posy,
            cl_double stepSizeX,
            cl_double stepSizeY,
            cl_int maxIterations,
            cl_int width,
            cl_int bench);


        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        
        cl_uint getWidth(void);

        
        cl_uint getHeight(void);

        inline cl_uint getMaxIterations(void)
        {
            return maxIterations;
        }
        inline void setMaxIterations(cl_uint maxIter)
        {
            maxIterations = maxIter;
        }

        inline cl_double getXSize(void)
        {
            return xsize;
        }
        inline void setXSize(cl_double xs)
        {
            xsize = xs;
        }
        inline cl_double getXStep(void)
        {
            return xstep;
        }
        inline cl_double getYStep(void)
        {
            return ystep;
        }
        inline cl_double getXPos(void)
        {
            return xpos;
        }
        inline cl_double getYPos(void)
        {
            return ypos;
        }
        inline void setXPos(cl_double xp)
        {
            if (xp < -2.0)
            {
                xp = -2.0;
            }
            else if (xp > 2.0)
            {
                xp = 2.0;
            }
            xpos = xp;
        }
        inline void setYPos(cl_double yp)
        {
            if (yp < -2.0)
            {
                yp = -2.0;
            }
            else if (yp > 2.0)
            {
                yp = 2.0;
            }
            ypos = yp;
        }
        inline void setBench(cl_int b)
        {
            bench = b;
        }
        inline cl_int getBenched(void)
        {
            return benched;
        }
        inline cl_int getTiming(void)
        {
            return sampleArgs->timing;
        }

        
        cl_uint * getPixels(void);

        
        cl_bool showWindow(void);
};

#endif
