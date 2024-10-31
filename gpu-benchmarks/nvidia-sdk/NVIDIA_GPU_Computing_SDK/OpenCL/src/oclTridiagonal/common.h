
 
 

#ifndef COMMON_H
#define COMMON_H


double executionTime(cl_event &event)
{
    cl_ulong start, end;
    
    clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &end, NULL);
    clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL);
    
    return ((double)end - (double)start) * 1.0e-9f;
}

#endif