


#ifndef NBODY_H_
#define NBODY_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#define GROUP_SIZE 128

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class NBody
{
        cl_double setupTime;                
        cl_double kernelTime;               

        cl_float delT;                      
        cl_float espSqr;                    
        cl_float* initPos;                  
        cl_float* initVel;                  
        cl_float* vel;                      
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem particlePos[2];              
        cl_mem particleVel[2];              
        int currentPosBufferIndex;
        unsigned int currentIterationCL;    
        float* mappedPosBuffer;             
        int mappedPosBufferIndex;
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;                   
        size_t groupSize;                   

        int iterations;
        SDKDeviceInfo
        deviceInfo;                
        KernelWorkGroupInfo
        kernelInfo;          

        int fpsTimer;
        int timerNumFrames;

        SDKTimer *sampleTimer;      

    private:

        float random(float randMax, float randMin);

    public:

        CLCommandArgs   *sampleArgs;   

        cl_int numParticles;
        bool    isFirstLuanch;
        cl_event glEvent;
        
        explicit NBody()
            : setupTime(0),
              kernelTime(0),
              delT(0.005f),
              espSqr(500.0f),
              initPos(NULL),
              initVel(NULL),
              vel(NULL),
              devices(NULL),
              groupSize(GROUP_SIZE),
              iterations(1),
              currentPosBufferIndex(0),
              currentIterationCL(0),
              mappedPosBuffer(NULL),
              fpsTimer(0),
              timerNumFrames(0),
              isFirstLuanch(true),
              glEvent(NULL)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            numParticles = 1024;
        }

        ~NBody();

        
        int setupNBody();

        
        int genBinaryImage();

        
        int setupCL();

        
        int setupCLKernels();

        
        int runCLKernels();

        
        void nBodyCPUReference(float* currentPos, float* currentVel
                               , float* newPos, float* newVel);


        float* getMappedParticlePositions();
        void releaseMappedParticlePositions();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();


        
        void initFPSTimer()
        {
            timerNumFrames = 0;
            fpsTimer = sampleTimer->createTimer();
            sampleTimer->resetTimer(fpsTimer);
            sampleTimer->startTimer(fpsTimer);
        };

        
        double getFPS()
        {
            sampleTimer->stopTimer(fpsTimer);
            double elapsedTime = sampleTimer->readTimer(fpsTimer);
            double fps = timerNumFrames/elapsedTime;
            timerNumFrames = 0;
            sampleTimer->resetTimer(fpsTimer);
            sampleTimer->startTimer(fpsTimer);
            return fps;
        };
};

#endif 
