


#ifndef TEMPLATE_H_
#define TEMPLATE_H_




#include <CL/cl.h>
#include <string.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>



#define SDK_SUCCESS 0
#define SDK_FAILURE 1


cl_uint *input;


cl_uint *output;


cl_uint multiplier;


cl_uint width;


cl_mem   inputBuffer;
cl_mem	 outputBuffer;

cl_context          context;
cl_device_id        *devices;
cl_command_queue    commandQueue;

cl_program program;


cl_kernel  kernel;





int initializeCL(void);


std::string convertToString(const char * filename);


int runCLKernels(void);


int cleanupCL(void);


void cleanupHost(void);


void print1DArray(
         const std::string arrayName, 
         const unsigned int * arrayData, 
         const unsigned int length);


#endif  
