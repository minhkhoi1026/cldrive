
#ifndef  _MemoryModel_H
#define  _MemoryModel_H

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <fstream>
#include <tchar.h> 

#define SDK_SUCCESS 0
#define SDK_FAILURE 1



cl_char *output;



cl_mem	 outputBuffer;

cl_context          context;
cl_device_id        *devices;
cl_command_queue    commandQueue;

cl_program program;

cl_kernel  kernel;

#endif