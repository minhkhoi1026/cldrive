
 
 #pragma once

#include<oclUtils.h>


class DeviceManager
{
public:
    DeviceManager(cl_platform_id cpPlatform, cl_uint* uiNumAllDevs, void (*pCleanup)(int));
    ~DeviceManager(void);

    int GetDevLoadProportions(bool bNV);

    cl_uint* uiUsefulDevs;      
    cl_uint uiUsefulDevCt;      
    float* fLoadProportions;    
    cl_device_id* cdDevices;    

private:
    cl_uint uiDevCount;         
    float* fDevPerfs;           
};
