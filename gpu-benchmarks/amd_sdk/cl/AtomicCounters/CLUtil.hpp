





#ifndef CLSample_H_
#define CLSample_H_

#include <CL/opencl.h>

#include "SDKUtil.hpp"
#include "SDKFile.hpp"

#define CHECK_OPENCL_ERROR(actual, msg) \
    if(checkVal(actual, CL_SUCCESS, msg)) \
    { \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return SDK_FAILURE; \
    }

#define OPENCL_EXPECTED_ERROR(msg) \
    { \
        expectedError(msg); \
        return SDK_EXPECTED_FAILURE; \
    }

#define CHECK_OPENVIDEO_ERROR(actual, msg) \
    if(checkVal(actual, CL_SUCCESS, msg)) \
    { \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return SDK_FAILURE; \
    }

#define OPENVIDEO_EXPECTED_ERROR(msg) \
    { \
        expectedError(msg); \
        return SDK_EXPECTED_FAILURE; \
    }

#define UNUSED(expr) (void)(expr);



#define CL_CONTEXT_OFFLINE_DEVICES_AMD        0x403F


namespace appsdk
{


struct bifData
{
    std::string kernelName;         
    std::string flagsFileName;      
    std::string flagsStr;           
    std::string binaryName;         

    
    bifData()
    {
        kernelName = std::string("");
        flagsFileName = std::string("");
        flagsStr = std::string("");
        binaryName = std::string("");
    }
};


struct buildProgramData
{
    std::string kernelName;             
    std::string
    flagsFileName;          
    std::string flagsStr;               
    std::string binaryName;             
    cl_device_id*
    devices;              
    int deviceId;                       

    
    buildProgramData()
    {
        kernelName = std::string("");
        flagsFileName = std::string("");
        flagsStr = std::string("");
        binaryName = std::string("");
    }
};


static const char* getOpenCLErrorCodeStr(std::string input)
{
    return "unknown error code";
}

template<typename T>
static const char* getOpenCLErrorCodeStr(T input)
{
    int errorCode = (int)input;
    switch(errorCode)
    {
    case CL_DEVICE_NOT_FOUND:
        return "CL_DEVICE_NOT_FOUND";
    case CL_DEVICE_NOT_AVAILABLE:
        return "CL_DEVICE_NOT_AVAILABLE";
    case CL_COMPILER_NOT_AVAILABLE:
        return "CL_COMPILER_NOT_AVAILABLE";
    case CL_MEM_OBJECT_ALLOCATION_FAILURE:
        return "CL_MEM_OBJECT_ALLOCATION_FAILURE";
    case CL_OUT_OF_RESOURCES:
        return "CL_OUT_OF_RESOURCES";
    case CL_OUT_OF_HOST_MEMORY:
        return "CL_OUT_OF_HOST_MEMORY";
    case CL_PROFILING_INFO_NOT_AVAILABLE:
        return "CL_PROFILING_INFO_NOT_AVAILABLE";
    case CL_MEM_COPY_OVERLAP:
        return "CL_MEM_COPY_OVERLAP";
    case CL_IMAGE_FORMAT_MISMATCH:
        return "CL_IMAGE_FORMAT_MISMATCH";
    case CL_IMAGE_FORMAT_NOT_SUPPORTED:
        return "CL_IMAGE_FORMAT_NOT_SUPPORTED";
    case CL_BUILD_PROGRAM_FAILURE:
        return "CL_BUILD_PROGRAM_FAILURE";
    case CL_MAP_FAILURE:
        return "CL_MAP_FAILURE";
    case CL_MISALIGNED_SUB_BUFFER_OFFSET:
        return "CL_MISALIGNED_SUB_BUFFER_OFFSET";
    case CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST:
        return "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST";
    case CL_INVALID_VALUE:
        return "CL_INVALID_VALUE";
    case CL_INVALID_DEVICE_TYPE:
        return "CL_INVALID_DEVICE_TYPE";
    case CL_INVALID_PLATFORM:
        return "CL_INVALID_PLATFORM";
    case CL_INVALID_DEVICE:
        return "CL_INVALID_DEVICE";
    case CL_INVALID_CONTEXT:
        return "CL_INVALID_CONTEXT";
    case CL_INVALID_QUEUE_PROPERTIES:
        return "CL_INVALID_QUEUE_PROPERTIES";
    case CL_INVALID_COMMAND_QUEUE:
        return "CL_INVALID_COMMAND_QUEUE";
    case CL_INVALID_HOST_PTR:
        return "CL_INVALID_HOST_PTR";
    case CL_INVALID_MEM_OBJECT:
        return "CL_INVALID_MEM_OBJECT";
    case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:
        return "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR";
    case CL_INVALID_IMAGE_SIZE:
        return "CL_INVALID_IMAGE_SIZE";
    case CL_INVALID_SAMPLER:
        return "CL_INVALID_SAMPLER";
    case CL_INVALID_BINARY:
        return "CL_INVALID_BINARY";
    case CL_INVALID_BUILD_OPTIONS:
        return "CL_INVALID_BUILD_OPTIONS";
    case CL_INVALID_PROGRAM:
        return "CL_INVALID_PROGRAM";
    case CL_INVALID_PROGRAM_EXECUTABLE:
        return "CL_INVALID_PROGRAM_EXECUTABLE";
    case CL_INVALID_KERNEL_NAME:
        return "CL_INVALID_KERNEL_NAME";
    case CL_INVALID_KERNEL_DEFINITION:
        return "CL_INVALID_KERNEL_DEFINITION";
    case CL_INVALID_KERNEL:
        return "CL_INVALID_KERNEL";
    case CL_INVALID_ARG_INDEX:
        return "CL_INVALID_ARG_INDEX";
    case CL_INVALID_ARG_VALUE:
        return "CL_INVALID_ARG_VALUE";
    case CL_INVALID_ARG_SIZE:
        return "CL_INVALID_ARG_SIZE";
    case CL_INVALID_KERNEL_ARGS:
        return "CL_INVALID_KERNEL_ARGS";
    case CL_INVALID_WORK_DIMENSION:
        return "CL_INVALID_WORK_DIMENSION";
    case CL_INVALID_WORK_GROUP_SIZE:
        return "CL_INVALID_WORK_GROUP_SIZE";
    case CL_INVALID_WORK_ITEM_SIZE:
        return "CL_INVALID_WORK_ITEM_SIZE";
    case CL_INVALID_GLOBAL_OFFSET:
        return "CL_INVALID_GLOBAL_OFFSET";
    case CL_INVALID_EVENT_WAIT_LIST:
        return "CL_INVALID_EVENT_WAIT_LIST";
    case CL_INVALID_EVENT:
        return "CL_INVALID_EVENT";
    case CL_INVALID_OPERATION:
        return "CL_INVALID_OPERATION";
    case CL_INVALID_GL_OBJECT:
        return "CL_INVALID_GL_OBJECT";
    case CL_INVALID_BUFFER_SIZE:
        return "CL_INVALID_BUFFER_SIZE";
    case CL_INVALID_MIP_LEVEL:
        return "CL_INVALID_MIP_LEVEL";
    case CL_INVALID_GLOBAL_WORK_SIZE:
        return "CL_INVALID_GLOBAL_WORK_SIZE";
    case CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR:
        return "CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR";
    case CL_PLATFORM_NOT_FOUND_KHR:
        return "CL_PLATFORM_NOT_FOUND_KHR";
        
        
    case CL_DEVICE_PARTITION_FAILED_EXT:
        return "CL_DEVICE_PARTITION_FAILED_EXT";
    case CL_INVALID_PARTITION_COUNT_EXT:
        return "CL_INVALID_PARTITION_COUNT_EXT";
    default:
        return "unknown error code";
    }
}


template<typename T>
static int checkVal(
    T input,
    T reference,
    std::string message, bool isAPIerror = true)
{
    if(input==reference)
    {
        return SDK_SUCCESS;
    }
    else
    {
        if(isAPIerror)
        {
            std::cout<<"Error: "<< message << " Error code : ";
            std::cout << getOpenCLErrorCodeStr(input) << std::endl;
        }
        else
        {
            error(message);
        }
        return SDK_FAILURE;
    }
}

static int displayDevices(cl_platform_id platform, cl_device_type deviceType)
{
    cl_int status;
    
    char platformVendor[1024];
    status = clGetPlatformInfo(platform, CL_PLATFORM_VENDOR, sizeof(platformVendor),
                               platformVendor, NULL);
    CHECK_OPENCL_ERROR(status, "clGetPlatformInfo failed");
    std::cout << "\nSelected Platform Vendor : " << platformVendor << std::endl;
    
    cl_uint deviceCount = 0;
    status = clGetDeviceIDs(platform, deviceType, 0, NULL, &deviceCount);
    CHECK_OPENCL_ERROR(status, "clGetDeviceIDs failed");
    cl_device_id* deviceIds = (cl_device_id*)malloc(sizeof(cl_device_id) *
                              deviceCount);
    CHECK_ALLOCATION(deviceIds, "Failed to allocate memory(deviceIds)");
    
    status = clGetDeviceIDs(platform, deviceType, deviceCount, deviceIds, NULL);
    CHECK_OPENCL_ERROR(status, "clGetDeviceIDs failed");
    
    for(cl_uint i = 0; i < deviceCount; ++i)
    {
        char deviceName[1024];
        status = clGetDeviceInfo(deviceIds[i], CL_DEVICE_NAME, sizeof(deviceName),
                                 deviceName, NULL);
        CHECK_OPENCL_ERROR(status, "clGetDeviceInfo failed");
        std::cout << "Device " << i << " : " << deviceName
                  <<" Device ID is "<<deviceIds[i]<< std::endl;
    }
    free(deviceIds);
    return SDK_SUCCESS;
}



static int displayPlatformAndDevices(cl_platform_id platform,
                              const cl_device_id* device, const int deviceCount)
{
    cl_int status;
    
    char platformVendor[1024];
    status = clGetPlatformInfo(platform, CL_PLATFORM_VENDOR, sizeof(platformVendor),
                               platformVendor, NULL);
    CHECK_OPENCL_ERROR(status, "clGetPlatformInfo failed");
    std::cout << "\nSelected Platform Vendor : " << platformVendor << std::endl;
    
    for(cl_int i = 0; i < deviceCount; ++i)
    {
        char deviceName[1024];
        status = clGetDeviceInfo(device[i], CL_DEVICE_NAME, sizeof(deviceName),
                                 deviceName, NULL);
        CHECK_OPENCL_ERROR(status, "clGetDeviceInfo failed");
        std::cout << "Device " << i << " : " << deviceName << std::endl;
    }
    return SDK_SUCCESS;
}



static int validateDeviceId(int deviceId, int deviceCount)
{
    
    if(deviceId >= (int)deviceCount)
    {
        std::cout << "DeviceId should be < " << deviceCount << std::endl;
        return SDK_FAILURE;
    }
    return SDK_SUCCESS;
}



static int generateBinaryImage(const bifData &binaryData)
{
    cl_int status = CL_SUCCESS;
    
    cl_uint numPlatforms;
    cl_platform_id platform = NULL;
    status = clGetPlatformIDs(0, NULL, &numPlatforms);
    CHECK_OPENCL_ERROR(status, "clGetPlatformIDs failed.");
    if (0 < numPlatforms)
    {
        cl_platform_id* platforms = new cl_platform_id[numPlatforms];
        status = clGetPlatformIDs(numPlatforms, platforms, NULL);
        CHECK_OPENCL_ERROR(status, "clGetPlatformIDs failed.");
        char platformName[100];
        for (unsigned i = 0; i < numPlatforms; ++i)
        {
            status = clGetPlatformInfo(
                         platforms[i],
                         CL_PLATFORM_VENDOR,
                         sizeof(platformName),
                         platformName,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetPlatformInfo failed.");
            platform = platforms[i];
            if (!strcmp(platformName, "Advanced Micro Devices, Inc."))
            {
                break;
            }
        }
        std::cout << "Platform found : " << platformName << "\n";
        delete[] platforms;
    }
    if(NULL == platform)
    {
        std::cout << "NULL platform found so Exiting Application.";
        return SDK_FAILURE;
    }
    
    cl_context_properties cps[5] =
    {
        CL_CONTEXT_PLATFORM,
        (cl_context_properties)platform,
        CL_CONTEXT_OFFLINE_DEVICES_AMD,
        (cl_context_properties)1,
        0
    };
    cl_context context = clCreateContextFromType(
                             cps,
                             CL_DEVICE_TYPE_ALL,
                             NULL,
                             NULL,
                             &status);
    CHECK_OPENCL_ERROR(status, "clCreateContextFromType failed.");
    
    SDKFile kernelFile;
    std::string kernelPath = getPath();
    kernelPath.append(binaryData.kernelName.c_str());
    if(!kernelFile.open(kernelPath.c_str()))
    {
        std::cout << "Failed to load kernel file : " << kernelPath << std::endl;
        return SDK_FAILURE;
    }
    const char * source = kernelFile.source().c_str();
    size_t sourceSize[] = {strlen(source)};
    cl_program program = clCreateProgramWithSource(
                             context,
                             1,
                             &source,
                             sourceSize,
                             &status);
    CHECK_OPENCL_ERROR(status, "clCreateProgramWithSource failed.");
    std::string flagsStr = std::string(binaryData.flagsStr.c_str());
    
    if(binaryData.flagsFileName.size() != 0)
    {
        SDKFile flagsFile;
        std::string flagsPath = getPath();
        flagsPath.append(binaryData.flagsFileName.c_str());
        if(!flagsFile.open(flagsPath.c_str()))
        {
            std::cout << "Failed to load flags file: " << flagsPath << std::endl;
            return SDK_FAILURE;
        }
        flagsFile.replaceNewlineWithSpaces();
        const char * flags = flagsFile.source().c_str();
        flagsStr.append(flags);
    }
    if(flagsStr.size() != 0)
    {
        std::cout << "Build Options are : " << flagsStr.c_str() << std::endl;
    }
    
    status = clBuildProgram(
                 program,
                 0,
                 NULL,
                 flagsStr.c_str(),
                 NULL,
                 NULL);
    
    
    size_t numDevices;
    status = clGetProgramInfo(
                 program,
                 CL_PROGRAM_NUM_DEVICES,
                 sizeof(numDevices),
                 &numDevices,
                 NULL );
    CHECK_OPENCL_ERROR(status, "clGetProgramInfo(CL_PROGRAM_NUM_DEVICES) failed.");
    std::cout << "Number of devices found : " << numDevices << "\n\n";
    cl_device_id *devices = (cl_device_id *)malloc( sizeof(cl_device_id) *
                            numDevices );
    CHECK_ALLOCATION(devices, "Failed to allocate host memory.(devices)");
    
    status = clGetProgramInfo(
                 program,
                 CL_PROGRAM_DEVICES,
                 sizeof(cl_device_id) * numDevices,
                 devices,
                 NULL );
    CHECK_OPENCL_ERROR(status, "clGetProgramInfo(CL_PROGRAM_DEVICES) failed.");
    
    size_t *binarySizes = (size_t*)malloc( sizeof(size_t) * numDevices );
    CHECK_ALLOCATION(binarySizes, "Failed to allocate host memory.(binarySizes)");
    status = clGetProgramInfo(
                 program,
                 CL_PROGRAM_BINARY_SIZES,
                 sizeof(size_t) * numDevices,
                 binarySizes,
                 NULL);
    CHECK_OPENCL_ERROR(status, "clGetProgramInfo(CL_PROGRAM_BINARY_SIZES) failed.");
    size_t i = 0;
    
    char **binaries = (char **)malloc( sizeof(char *) * numDevices );
    CHECK_ALLOCATION(binaries, "Failed to allocate host memory.(binaries)");
    for(i = 0; i < numDevices; i++)
    {
        if(binarySizes[i] != 0)
        {
            binaries[i] = (char *)malloc( sizeof(char) * binarySizes[i]);
            CHECK_ALLOCATION(binaries[i], "Failed to allocate host memory.(binaries[i])");
        }
        else
        {
            binaries[i] = NULL;
        }
    }
    status = clGetProgramInfo(
                 program,
                 CL_PROGRAM_BINARIES,
                 sizeof(char *) * numDevices,
                 binaries,
                 NULL);
    CHECK_OPENCL_ERROR(status, "clGetProgramInfo(CL_PROGRAM_BINARIES) failed.");
    
    for(i = 0; i < numDevices; i++)
    {
        char fileName[100];
        sprintf(fileName, "%s.%d", binaryData.binaryName.c_str(), (int)i);
        char deviceName[1024];
        status = clGetDeviceInfo(
                     devices[i],
                     CL_DEVICE_NAME,
                     sizeof(deviceName),
                     deviceName,
                     NULL);
        CHECK_OPENCL_ERROR(status, "clGetDeviceInfo(CL_DEVICE_NAME) failed.");
        if(binarySizes[i] != 0)
        {
            printf( "%s binary kernel: %s\n", deviceName, fileName);
            SDKFile BinaryFile;
            if(BinaryFile.writeBinaryToFile(fileName,
                                            binaries[i],
                                            binarySizes[i]))
            {
                std::cout << "Failed to load kernel file : " << fileName << std::endl;
                return SDK_FAILURE;
            }
        }
        else
        {
            printf(
                "%s binary kernel(%s) : %s\n",
                deviceName,
                fileName,
                "Skipping as there is no binary data to write!");
        }
    }
    
    for(i = 0; i < numDevices; i++)
    {
        if(binaries[i] != NULL)
        {
            free(binaries[i]);
            binaries[i] = NULL;
        }
    }
    if(binaries != NULL)
    {
        free(binaries);
        binaries = NULL;
    }
    if(binarySizes != NULL)
    {
        free(binarySizes);
        binarySizes = NULL;
    }
    if(devices != NULL)
    {
        free(devices);
        devices = NULL;
    }
    status = clReleaseProgram(program);
    CHECK_OPENCL_ERROR(status, "clReleaseProgram failed.");
    status = clReleaseContext(context);
    CHECK_OPENCL_ERROR(status, "clReleaseContext failed.");
    return SDK_SUCCESS;
}


static int getPlatform(cl_platform_id &platform, int platformId,
                bool platformIdEnabled)
{
    cl_uint numPlatforms;
    cl_int status = clGetPlatformIDs(0, NULL, &numPlatforms);
    CHECK_OPENCL_ERROR(status, "clGetPlatformIDs failed.");
    if (0 < numPlatforms)
    {
        cl_platform_id* platforms = new cl_platform_id[numPlatforms];
        status = clGetPlatformIDs(numPlatforms, platforms, NULL);
        CHECK_OPENCL_ERROR(status, "clGetPlatformIDs failed.");
        if(platformIdEnabled)
        {
            platform = platforms[platformId];
        }
        else
        {
            char platformName[100];
            for (unsigned i = 0; i < numPlatforms; ++i)
            {
                status = clGetPlatformInfo(platforms[i],
                                           CL_PLATFORM_VENDOR,
                                           sizeof(platformName),
                                           platformName,
                                           NULL);
                CHECK_OPENCL_ERROR(status, "clGetPlatformInfo failed.");
                platform = platforms[i];
                if (!strcmp(platformName, "Advanced Micro Devices, Inc."))
                {
                    break;
                }
            }
            std::cout << "Platform found : " << platformName << "\n";
        }
        delete[] platforms;
    }
    if(NULL == platform)
    {
        error("NULL platform found so Exiting Application.");
        return SDK_FAILURE;
    }
    return SDK_SUCCESS;
}


static int getDevices(cl_context &context, cl_device_id **devices, int deviceId,
               bool deviceIdEnabled)
{
    
    size_t deviceListSize = 0;
    int status = 0;
    status = clGetContextInfo(
                 context,
                 CL_CONTEXT_DEVICES,
                 0,
                 NULL,
                 &deviceListSize);
    CHECK_OPENCL_ERROR(status, "clGetContextInfo failed.");
    int deviceCount = (int)(deviceListSize / sizeof(cl_device_id));
    if(validateDeviceId(deviceId, deviceCount))
    {
        std::cout << "Invalid Device Selected";
        return SDK_FAILURE;
    }
    
    (*devices) = (cl_device_id *)malloc(deviceListSize);
    CHECK_ALLOCATION((*devices), "Failed to allocate memory (devices).");
    
    status = clGetContextInfo(context,
                              CL_CONTEXT_DEVICES,
                              deviceListSize,
                              (*devices),
                              NULL);
    CHECK_OPENCL_ERROR(status, "clGetGetContextInfo failed.");
    UNUSED(deviceIdEnabled);
    return SDK_SUCCESS;
}


static int buildOpenCLProgram(cl_program &program, const cl_context& context,
                       const buildProgramData &buildData)
{
    cl_int status = CL_SUCCESS;
    SDKFile kernelFile;
    std::string kernelPath = getPath();
    if(buildData.binaryName.size() != 0)
    {
        kernelPath.append(buildData.binaryName.c_str());
        if(kernelFile.readBinaryFromFile(kernelPath.c_str()))
        {
            std::cout << "Failed to load kernel file : " << kernelPath << std::endl;
            return SDK_FAILURE;
        }
        const char * binary = kernelFile.source().c_str();
        size_t binarySize = kernelFile.source().size();
        program = clCreateProgramWithBinary(context,
                                            1,
                                            &buildData.devices[buildData.deviceId],
                                            (const size_t *)&binarySize,
                                            (const unsigned char**)&binary,
                                            NULL,
                                            &status);
        CHECK_OPENCL_ERROR(status, "clCreateProgramWithBinary failed.");
    }
    else
    {
        kernelPath.append(buildData.kernelName.c_str());
        if(!kernelFile.open(kernelPath.c_str()))
        {
            std::cout << "Failed to load kernel file: " << kernelPath << std::endl;
            return SDK_FAILURE;
        }
        const char * source = kernelFile.source().c_str();
        size_t sourceSize[] = {strlen(source)};
        program = clCreateProgramWithSource(context,
                                            1,
                                            &source,
                                            sourceSize,
                                            &status);
        CHECK_OPENCL_ERROR(status, "clCreateProgramWithSource failed.");
    }
    std::string flagsStr = std::string(buildData.flagsStr.c_str());
    
    if(buildData.flagsFileName.size() != 0)
    {
        SDKFile flagsFile;
        std::string flagsPath = getPath();
        flagsPath.append(buildData.flagsFileName.c_str());
        if(!flagsFile.open(flagsPath.c_str()))
        {
            std::cout << "Failed to load flags file: " << flagsPath << std::endl;
            return SDK_FAILURE;
        }
        flagsFile.replaceNewlineWithSpaces();
        const char * flags = flagsFile.source().c_str();
        flagsStr.append(flags);
    }
    if(flagsStr.size() != 0)
    {
        std::cout << "Build Options are : " << flagsStr.c_str() << std::endl;
    }
    
    status = clBuildProgram(program, 1, &buildData.devices[buildData.deviceId],
                            flagsStr.c_str(), NULL, NULL);
    if(status != CL_SUCCESS)
    {
        if(status == CL_BUILD_PROGRAM_FAILURE)
        {
            cl_int logStatus;
            char *buildLog = NULL;
            size_t buildLogSize = 0;
            logStatus = clGetProgramBuildInfo (
                            program,
                            buildData.devices[buildData.deviceId],
                            CL_PROGRAM_BUILD_LOG,
                            buildLogSize,
                            buildLog,
                            &buildLogSize);
            CHECK_OPENCL_ERROR(logStatus, "clGetProgramBuildInfo failed.");
            buildLog = (char*)malloc(buildLogSize);
            CHECK_ALLOCATION(buildLog, "Failed to allocate host memory. (buildLog)");
            memset(buildLog, 0, buildLogSize);
            logStatus = clGetProgramBuildInfo (
                            program,
                            buildData.devices[buildData.deviceId],
                            CL_PROGRAM_BUILD_LOG,
                            buildLogSize,
                            buildLog,
                            NULL);
            if(checkVal(logStatus, CL_SUCCESS, "clGetProgramBuildInfo failed."))
            {
                free(buildLog);
                return SDK_FAILURE;
            }
            std::cout << " \n\t\t\tBUILD LOG\n";
            std::cout << " ************************************************\n";
            std::cout << buildLog << std::endl;
            std::cout << " ************************************************\n";
            free(buildLog);
        }
        CHECK_OPENCL_ERROR(status, "clBuildProgram failed.");
    }
    return SDK_SUCCESS;
}



static int waitForEventAndRelease(cl_event *event)
{
    cl_int status = CL_SUCCESS;
    cl_int eventStatus = CL_QUEUED;
    while(eventStatus != CL_COMPLETE)
    {
        status = clGetEventInfo(
                     *event,
                     CL_EVENT_COMMAND_EXECUTION_STATUS,
                     sizeof(cl_int),
                     &eventStatus,
                     NULL);
        CHECK_OPENCL_ERROR(status, "clGetEventEventInfo Failed with Error Code:");
    }
    status = clReleaseEvent(*event);
    CHECK_OPENCL_ERROR(status, "clReleaseEvent Failed with Error Code:");
    return SDK_SUCCESS;
}


static size_t getLocalThreads(size_t globalThreads, size_t maxWorkItemSize)
{
    if(maxWorkItemSize < globalThreads)
    {
        if(globalThreads%maxWorkItemSize == 0)
        {
            return maxWorkItemSize;
        }
        else
        {
            for(size_t i=maxWorkItemSize-1; i > 0; --i)
            {
                if(globalThreads%i == 0)
                {
                    return i;
                }
            }
        }
    }
    else
    {
        return globalThreads;
    }
    return SDK_SUCCESS;
}



inline std::string getExactVerStr(std::string clVerStr)
{
    std::string finalVerStr("");
    size_t vPos = clVerStr.find_first_of("v");
    
    if(vPos == std::string::npos)
    {
        
        size_t sPos = clVerStr.find_first_of(" ");
        sPos = clVerStr.find_first_of(" ", sPos + 1);
        finalVerStr = clVerStr.substr(0, sPos + 1);
        
        std::string sdkStr = getSdkVerStr();
        size_t bPos = sdkStr.find_first_of("(");
        finalVerStr.append(sdkStr.substr(0, bPos + 1));
        
        vPos = clVerStr.find_first_of("(");
        finalVerStr.append(clVerStr.substr(vPos + 1));
    }
    else
    {
        finalVerStr = clVerStr;
    }
    return finalVerStr;
}


class CLCommandArgs : public SDKCmdArgsParser
{

    protected:
        
        
        bool enableDeviceId;           
        bool enablePlatform;           
        bool gpu;                      
        bool amdPlatform;              
    public:
        bool multiDevice;              
        unsigned int deviceId;         
        unsigned int platformId;       
        std::string deviceType;        
        std::string dumpBinary;        
        std::string loadBinary;        
        std::string flags;             

        
        CLCommandArgs(bool enableMultiDevice = false)
            :SDKCmdArgsParser ()
        {
            deviceType = "gpu";
            multiDevice = enableMultiDevice;
            deviceId = 0;
            platformId = 0;
            enablePlatform = false;
            enableDeviceId = false;
            gpu = true;
            amdPlatform = false;
        }

        
        bool isDumpBinaryEnabled()
        {
            if(dumpBinary.size() == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        
        bool isLoadBinaryEnabled()
        {
            if(loadBinary.size() == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        
        bool isComplierFlagsSpecified()
        {
            if(flags.size() == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        
        bool isPlatformEnabled()
        {
            return enablePlatform;
        }

        
        bool isDeviceIdEnabled()
        {
            return enableDeviceId;
        }

        
        bool isThereGPU()
        {
            return gpu;
        }

        
        bool isAmdPlatform()
        {
            return amdPlatform;
        }


        
        int parseCommandLine(int argc, char **argv)
        {
            if(!parse(argv,argc))
            {
                usage();
                if((isArgSet("h",true) == true) || (isArgSet("help",true) == true))
                {
                    exit(SDK_SUCCESS);
                }
                return SDK_FAILURE;
            }
            if((isArgSet("h",true) == true) || (isArgSet("help",true) == true))
            {
                usage();
                exit(SDK_SUCCESS);
            }
            
            if(isArgSet("v", true) || isArgSet("version", false))
            {
                std::cout << "SDK version : " << sampleVerStr.c_str() << std::endl;
                exit(0);
            }
            if(isArgSet("p",true) || isArgSet("platformId",false))
            {
                enablePlatform = true;
            }
            if(isArgSet("d",true) || isArgSet("deviceId",false))
            {
                enableDeviceId = true;
            }
            
            if(multiDevice)
            {
                if(!((deviceType.compare("cpu") == 0 )
                        || (deviceType.compare("gpu") ==0)
                        || (deviceType.compare("all") ==0)))
                {
                    std::cout << "Error. Invalid device options. "
                              << "only \"cpu\" or \"gpu\" or \"all\" supported\n";
                    usage();
                    return SDK_FAILURE;
                }
            }
            else
            {
                if(!((deviceType.compare("cpu") == 0 ) || (deviceType.compare("gpu") ==0)))
                {
                    std::cout << "Error. Invalid device options. "
                              << "only \"cpu\" or \"gpu\" or \"all\" supported\n";
                    usage();
                    return SDK_FAILURE;
                }
            }
            if(dumpBinary.size() != 0 && loadBinary.size() != 0)
            {
                std::cout << "Error. --dump and --load options are mutually exclusive\n";
                usage();
                return SDK_FAILURE;
            }
            if(loadBinary.size() != 0 && flags.size() != 0)
            {
                std::cout << "Error. --flags and --load options are mutually exclusive\n";
                usage();
                return SDK_FAILURE;
            }
            if(validatePlatformAndDeviceOptions() != SDK_SUCCESS)
            {
                std::cout << "validatePlatfromAndDeviceOptions failed.\n ";
                return SDK_FAILURE;
            }
            return SDK_SUCCESS;
        }

        
        int validatePlatformAndDeviceOptions()
        {
            cl_int status = CL_SUCCESS;
            cl_uint numPlatforms;
            cl_platform_id platform = NULL;
            status = clGetPlatformIDs(0, NULL, &numPlatforms);
            if(status != CL_SUCCESS)
            {
                std::cout<<"Error: clGetPlatformIDs failed. Error code : ";
                std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                return SDK_FAILURE;
            }
            if (0 < numPlatforms)
            {
                
                if(platformId >= numPlatforms)
                {
                    if(numPlatforms - 1 == 0)
                    {
                        std::cout << "platformId should be 0" << std::endl;
                    }
                    else
                    {
                        std::cout << "platformId should be 0 to " << numPlatforms - 1 << std::endl;
                    }
                    usage();
                    return SDK_FAILURE;
                }
                
                cl_platform_id* platforms = new cl_platform_id[numPlatforms];
                status = clGetPlatformIDs(numPlatforms, platforms, NULL);
                if(status != CL_SUCCESS)
                {
                    std::cout<<"Error: clGetPlatformIDs failed. Error code : ";
                    std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                    return SDK_FAILURE;
                }
                
                for (unsigned i = 0; i < numPlatforms; ++i)
                {
                    char pbuf[100];
                    status = clGetPlatformInfo(platforms[i],
                                               CL_PLATFORM_VENDOR,
                                               sizeof(pbuf),
                                               pbuf,
                                               NULL);
                    if(status != CL_SUCCESS)
                    {
                        std::cout<<"Error: clGetPlatformInfo failed. Error code : ";
                        std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                        return SDK_FAILURE;
                    }
                    std::cout << "Platform " << i << " : " << pbuf << std::endl;
                }
                
                for (unsigned i = 0; i < numPlatforms; ++i)
                {
                    char pbuf[100];
                    status = clGetPlatformInfo(platforms[i],
                                               CL_PLATFORM_VENDOR,
                                               sizeof(pbuf),
                                               pbuf,
                                               NULL);
                    if(status != CL_SUCCESS)
                    {
                        std::cout<<"Error: clGetPlatformInfo failed. Error code : ";
                        std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                        return SDK_FAILURE;
                    }
                    platform = platforms[i];
                    if (!strcmp(pbuf, "Advanced Micro Devices, Inc."))
                    {
                        break;
                    }
                }
                if(isPlatformEnabled())
                {
                    platform = platforms[platformId];
                }
                
                char pbuf[100];
                status = clGetPlatformInfo(platform,
                                           CL_PLATFORM_VENDOR,
                                           sizeof(pbuf),
                                           pbuf,
                                           NULL);
                if(status != CL_SUCCESS)
                {
                    std::cout<<"Error: clGetPlatformInfo failed. Error code : ";
                    std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                    return SDK_FAILURE;
                }
                if (!strcmp(pbuf, "Advanced Micro Devices, Inc."))
                {
                    amdPlatform = true;
                }
                cl_device_type dType = CL_DEVICE_TYPE_GPU;
                if(deviceType.compare("cpu") == 0)
                {
                    dType = CL_DEVICE_TYPE_CPU;
                }
                if(deviceType.compare("gpu") == 0)
                {
                    dType = CL_DEVICE_TYPE_GPU;
                }
                else
                {
                    dType = CL_DEVICE_TYPE_ALL;
                }
                
                if(dType == CL_DEVICE_TYPE_GPU)
                {
                    cl_context_properties cps[3] =
                    {
                        CL_CONTEXT_PLATFORM,
                        (cl_context_properties)platform,
                        0
                    };
                    cl_context context = clCreateContextFromType(cps,
                                         dType,
                                         NULL,
                                         NULL,
                                         &status);
                    if(status == CL_DEVICE_NOT_FOUND)
                    {
                        dType = CL_DEVICE_TYPE_CPU;
                        gpu = false;
                    }
                    clReleaseContext(context);
                }
                
                cl_uint deviceCount = 0;
                status = clGetDeviceIDs(platform, dType, 0, NULL, &deviceCount);
                if(status != CL_SUCCESS)
                {
                    std::cout<<"Error: clGetDeviceIDs failed. Error code : ";
                    std::cout << getOpenCLErrorCodeStr(status) << std::endl;
                    return SDK_FAILURE;
                }
                
                if(deviceId >= deviceCount)
                {
                    if(deviceCount - 1 == 0)
                    {
                        std::cout << "deviceId should be 0" << std::endl;
                    }
                    else
                    {
                        std::cout << "deviceId should be 0 to " << deviceCount - 1 << std::endl;
                    }
                    usage();
                    return SDK_FAILURE;
                }
                delete[] platforms;
            }
            return SDK_SUCCESS;
        }
        int initialize()
        {
            int defaultOptions = 10;
            if(multiDevice)
            {
                defaultOptions = 9;
            }
            Option *optionList = new Option[defaultOptions];
            CHECK_ALLOCATION(optionList, "Error. Failed to allocate memory (optionList)\n");
            optionList[0]._sVersion = "";
            optionList[0]._lVersion = "device";
            if(multiDevice)
            {
                optionList[0]._description = "Execute the openCL kernel on a device";
                optionList[0]._usage = "[cpu|gpu|all]";
            }
            else
            {
                optionList[0]._description = "Execute the openCL kernel on a device";
                optionList[0]._usage = "[cpu|gpu]";
            }
            optionList[0]._type = CA_ARG_STRING;
            optionList[0]._value = &deviceType;
            optionList[1]._sVersion = "q";
            optionList[1]._lVersion = "quiet";
            optionList[1]._description = "Quiet mode. Suppress all text output.";
            optionList[1]._usage = "";
            optionList[1]._type = CA_NO_ARGUMENT;
            optionList[1]._value = &quiet;
            optionList[2]._sVersion = "e";
            optionList[2]._lVersion = "verify";
            optionList[2]._description = "Verify results against reference implementation.";
            optionList[2]._usage = "";
            optionList[2]._type = CA_NO_ARGUMENT;
            optionList[2]._value = &verify;
            optionList[3]._sVersion = "t";
            optionList[3]._lVersion = "timing";
            optionList[3]._description = "Print timing.";
            optionList[3]._type = CA_NO_ARGUMENT;
            optionList[3]._value = &timing;
            optionList[4]._sVersion = "";
            optionList[4]._lVersion = "dump";
            optionList[4]._description = "Dump binary image for all devices";
            optionList[4]._usage = "[filename]";
            optionList[4]._type = CA_ARG_STRING;
            optionList[4]._value = &dumpBinary;
            optionList[5]._sVersion = "";
            optionList[5]._lVersion = "load";
            optionList[5]._description = "Load binary image and execute on device";
            optionList[5]._usage = "[filename]";
            optionList[5]._type = CA_ARG_STRING;
            optionList[5]._value = &loadBinary;
            optionList[6]._sVersion = "";
            optionList[6]._lVersion = "flags";
            optionList[6]._description =
                "Specify filename containing the compiler flags to build kernel";
            optionList[6]._usage = "[filename]";
            optionList[6]._type = CA_ARG_STRING;
            optionList[6]._value = &flags;
            optionList[7]._sVersion = "p";
            optionList[7]._lVersion = "platformId";
            optionList[7]._description =
                "Select platformId to be used[0 to N-1 where N is number platforms available].";
            optionList[7]._usage = "[value]";
            optionList[7]._type = CA_ARG_INT;
            optionList[7]._value = &platformId;
            optionList[8]._sVersion = "v";
            optionList[8]._lVersion = "version";
            optionList[8]._description = "AMD APP SDK version string.";
            optionList[8]._usage = "";
            optionList[8]._type = CA_NO_ARGUMENT;
            optionList[8]._value = &version;
            if(multiDevice == false)
            {
                optionList[9]._sVersion = "d";
                optionList[9]._lVersion = "deviceId";
                optionList[9]._description =
                    "Select deviceId to be used[0 to N-1 where N is number devices available].";
                optionList[9]._usage = "[value]";
                optionList[9]._type = CA_ARG_INT;
                optionList[9]._value = &deviceId;
            }
            _numArgs = defaultOptions;
            _options = optionList;
            return SDK_SUCCESS;
        }

};



class KernelWorkGroupInfo
{
    public:
        cl_ulong localMemoryUsed;           
        size_t kernelWorkGroupSize;         
        size_t compileWorkGroupSize[3];     

        
        KernelWorkGroupInfo():
            localMemoryUsed(0),
            kernelWorkGroupSize(0)
        {
            compileWorkGroupSize[0] = 0;
            compileWorkGroupSize[1] = 0;
            compileWorkGroupSize[2] = 0;
        }

        
        int setKernelWorkGroupInfo(cl_kernel &kernel,cl_device_id &deviceId)
        {
            cl_int status = CL_SUCCESS;
            
            status = clGetKernelWorkGroupInfo(kernel,
                                              deviceId,
                                              CL_KERNEL_WORK_GROUP_SIZE,
                                              sizeof(size_t),
                                              &kernelWorkGroupSize,
                                              NULL);
            if(checkVal(status, CL_SUCCESS,
                        "clGetKernelWorkGroupInfo failed(CL_KERNEL_WORK_GROUP_SIZE)"))
            {
                return SDK_FAILURE;
            }
            status = clGetKernelWorkGroupInfo(kernel,
                                              deviceId,
                                              CL_KERNEL_LOCAL_MEM_SIZE,
                                              sizeof(cl_ulong),
                                              &localMemoryUsed,
                                              NULL);
            if(checkVal(status, CL_SUCCESS,
                        "clGetKernelWorkGroupInfo failed(CL_KERNEL_LOCAL_MEM_SIZE)"))
            {
                return SDK_FAILURE;
            }
            status = clGetKernelWorkGroupInfo(kernel,
                                              deviceId,
                                              CL_KERNEL_COMPILE_WORK_GROUP_SIZE,
                                              sizeof(size_t) * 3,
                                              compileWorkGroupSize,
                                              NULL);
            if(checkVal(status, CL_SUCCESS,
                        "clGetKernelWorkGroupInfo failed(CL_KERNEL_COMPILE_WORK_GROUP_SIZE)"))
            {
                return SDK_FAILURE;
            }
            return SDK_SUCCESS;
        }
    private :

        
        template<typename T>
        int checkVal(T input, T reference, std::string message,
                     bool isAPIerror = true) const
        {
            if(input==reference)
            {
                return 0;
            }
            else
            {
                if(isAPIerror)
                {
                    std::cout<<"Error: "<< message << " Error code : ";
                    std::cout << getOpenCLErrorCodeStr(input) << std::endl;
                }
                else
                {
                    std::cout << message;
                }
                return 1;
            }
        }

};


class SDKDeviceInfo
{
    public :
        cl_device_type dType;               
        cl_uint venderId;                   
        cl_uint maxComputeUnits;            
        cl_uint maxWorkItemDims;            
        size_t* maxWorkItemSizes;           
        size_t maxWorkGroupSize;            
        cl_uint preferredCharVecWidth;      
        cl_uint preferredShortVecWidth;     
        cl_uint preferredIntVecWidth;       
        cl_uint preferredLongVecWidth;      
        cl_uint preferredFloatVecWidth;     
        cl_uint preferredDoubleVecWidth;    
        cl_uint preferredHalfVecWidth;      
        cl_uint nativeCharVecWidth;         
        cl_uint nativeShortVecWidth;        
        cl_uint nativeIntVecWidth;          
        cl_uint nativeLongVecWidth;         
        cl_uint nativeFloatVecWidth;        
        cl_uint nativeDoubleVecWidth;       
        cl_uint nativeHalfVecWidth;         
        cl_uint maxClockFrequency;          
        cl_uint addressBits;                
        cl_ulong maxMemAllocSize;           
        cl_bool imageSupport;               
        cl_uint maxReadImageArgs;           
        cl_uint maxWriteImageArgs;          
        size_t image2dMaxWidth;             
        size_t image2dMaxHeight;            
        size_t image3dMaxWidth;             
        size_t image3dMaxHeight;            
        size_t image3dMaxDepth;             
        size_t maxSamplers;                 
        size_t maxParameterSize;            
        cl_uint memBaseAddressAlign;        
        cl_uint minDataTypeAlignSize;       
        cl_device_fp_config
        singleFpConfig; 
        cl_device_fp_config
        doubleFpConfig; 
        cl_device_mem_cache_type
        globleMemCacheType; 
        cl_uint globalMemCachelineSize;     
        cl_ulong globalMemCacheSize;        
        cl_ulong globalMemSize;             
        cl_ulong maxConstBufSize;           
        cl_uint maxConstArgs;               
        cl_device_local_mem_type
        localMemType;
        cl_ulong localMemSize;              
        cl_bool errCorrectionSupport;       
        cl_bool hostUnifiedMem;             
        size_t timerResolution;             
        cl_bool endianLittle;               
        cl_bool available;                  
        cl_bool compilerAvailable;          
        cl_device_exec_capabilities
        execCapabilities;
        cl_command_queue_properties
        queueProperties;
        cl_platform_id platform;            
        char* name;                         
        char* vendorName;                   
        char* driverVersion;                
        char* profileType;                  
        char* deviceVersion;                
        char* openclCVersion;               
        char* extensions;                   

        
        SDKDeviceInfo()
        {
            dType = CL_DEVICE_TYPE_GPU;
            venderId = 0;
            maxComputeUnits = 0;
            maxWorkItemDims = 0;
            maxWorkItemSizes = NULL;
            maxWorkGroupSize = 0;
            preferredCharVecWidth = 0;
            preferredShortVecWidth = 0;
            preferredIntVecWidth = 0;
            preferredLongVecWidth = 0;
            preferredFloatVecWidth = 0;
            preferredDoubleVecWidth = 0;
            preferredHalfVecWidth = 0;
            nativeCharVecWidth = 0;
            nativeShortVecWidth = 0;
            nativeIntVecWidth = 0;
            nativeLongVecWidth = 0;
            nativeFloatVecWidth = 0;
            nativeDoubleVecWidth = 0;
            nativeHalfVecWidth = 0;
            maxClockFrequency = 0;
            addressBits = 0;
            maxMemAllocSize = 0;
            imageSupport = CL_FALSE;
            maxReadImageArgs = 0;
            maxWriteImageArgs = 0;
            image2dMaxWidth = 0;
            image2dMaxHeight = 0;
            image3dMaxWidth = 0;
            image3dMaxHeight = 0;
            image3dMaxDepth = 0;
            maxSamplers = 0;
            maxParameterSize = 0;
            memBaseAddressAlign = 0;
            minDataTypeAlignSize = 0;
            singleFpConfig = CL_FP_ROUND_TO_NEAREST | CL_FP_INF_NAN;
            doubleFpConfig = CL_FP_FMA |
                             CL_FP_ROUND_TO_NEAREST |
                             CL_FP_ROUND_TO_ZERO |
                             CL_FP_ROUND_TO_INF |
                             CL_FP_INF_NAN |
                             CL_FP_DENORM;
            globleMemCacheType = CL_NONE;
            globalMemCachelineSize = CL_NONE;
            globalMemCacheSize = 0;
            globalMemSize = 0;
            maxConstBufSize = 0;
            maxConstArgs = 0;
            localMemType = CL_LOCAL;
            localMemSize = 0;
            errCorrectionSupport = CL_FALSE;
            hostUnifiedMem = CL_FALSE;
            timerResolution = 0;
            endianLittle = CL_FALSE;
            available = CL_FALSE;
            compilerAvailable = CL_FALSE;
            execCapabilities = CL_EXEC_KERNEL;
            queueProperties = 0;
            platform = 0;
            name = NULL;
            vendorName = NULL;
            driverVersion = NULL;
            profileType = NULL;
            deviceVersion = NULL;
            openclCVersion = NULL;
            extensions = NULL;
        };

        
        ~SDKDeviceInfo()
        {
            delete maxWorkItemSizes;
            delete name;
            delete vendorName;
            delete driverVersion;
            delete profileType;
            delete deviceVersion;
            delete openclCVersion;
            delete extensions;
        };

        
        int setDeviceInfo(cl_device_id deviceId)
        {
            cl_int status = CL_SUCCESS;
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_TYPE,
                         sizeof(cl_device_type),
                         &dType,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_TYPE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_VENDOR_ID,
                         sizeof(cl_uint),
                         &venderId,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_VENDOR_ID) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_COMPUTE_UNITS,
                         sizeof(cl_uint),
                         &maxComputeUnits,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_COMPUTE_UNITS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS,
                         sizeof(cl_uint),
                         &maxWorkItemDims,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS) failed");
            
            delete maxWorkItemSizes;
            maxWorkItemSizes = new size_t[maxWorkItemDims];
            CHECK_ALLOCATION(maxWorkItemSizes,
                             "Failed to allocate memory(maxWorkItemSizes)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_WORK_ITEM_SIZES,
                         maxWorkItemDims * sizeof(size_t),
                         maxWorkItemSizes,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_WORK_GROUP_SIZE,
                         sizeof(size_t),
                         &maxWorkGroupSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_WORK_GROUP_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR,
                         sizeof(cl_uint),
                         &preferredCharVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT,
                         sizeof(cl_uint),
                         &preferredShortVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT,
                         sizeof(cl_uint),
                         &preferredIntVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG,
                         sizeof(cl_uint),
                         &preferredLongVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT,
                         sizeof(cl_uint),
                         &preferredFloatVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE,
                         sizeof(cl_uint),
                         &preferredDoubleVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF,
                         sizeof(cl_uint),
                         &preferredHalfVecWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_CLOCK_FREQUENCY,
                         sizeof(cl_uint),
                         &maxClockFrequency,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_CLOCK_FREQUENCY) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_ADDRESS_BITS,
                         sizeof(cl_uint),
                         &addressBits,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_ADDRESS_BITS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_MEM_ALLOC_SIZE,
                         sizeof(cl_ulong),
                         &maxMemAllocSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_MEM_ALLOC_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE_SUPPORT,
                         sizeof(cl_bool),
                         &imageSupport,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_IMAGE_SUPPORT) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_READ_IMAGE_ARGS,
                         sizeof(cl_uint),
                         &maxReadImageArgs,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_READ_IMAGE_ARGS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_WRITE_IMAGE_ARGS,
                         sizeof(cl_uint),
                         &maxWriteImageArgs,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_WRITE_IMAGE_ARGS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE2D_MAX_WIDTH,
                         sizeof(size_t),
                         &image2dMaxWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_IMAGE2D_MAX_WIDTH) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE2D_MAX_HEIGHT,
                         sizeof(size_t),
                         &image2dMaxHeight,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_IMAGE2D_MAX_HEIGHT) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE3D_MAX_WIDTH,
                         sizeof(size_t),
                         &image3dMaxWidth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_IMAGE3D_MAX_WIDTH) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE3D_MAX_HEIGHT,
                         sizeof(size_t),
                         &image3dMaxHeight,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_IMAGE3D_MAX_HEIGHT) failed");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_IMAGE3D_MAX_DEPTH,
                         sizeof(size_t),
                         &image3dMaxDepth,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_IMAGE3D_MAX_DEPTH) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_SAMPLERS,
                         sizeof(cl_uint),
                         &maxSamplers,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_MAX_SAMPLERS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_PARAMETER_SIZE,
                         sizeof(size_t),
                         &maxParameterSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_PARAMETER_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MEM_BASE_ADDR_ALIGN,
                         sizeof(cl_uint),
                         &memBaseAddressAlign,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MEM_BASE_ADDR_ALIGN) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE,
                         sizeof(cl_uint),
                         &minDataTypeAlignSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_SINGLE_FP_CONFIG,
                         sizeof(cl_device_fp_config),
                         &singleFpConfig,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_SINGLE_FP_CONFIG) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_DOUBLE_FP_CONFIG,
                         sizeof(cl_device_fp_config),
                         &doubleFpConfig,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_DOUBLE_FP_CONFIG) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_GLOBAL_MEM_CACHE_TYPE,
                         sizeof(cl_device_mem_cache_type),
                         &globleMemCacheType,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_GLOBAL_MEM_CACHE_TYPE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE,
                         sizeof(cl_uint),
                         &globalMemCachelineSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_GLOBAL_MEM_CACHE_SIZE,
                         sizeof(cl_ulong),
                         &globalMemCacheSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_GLOBAL_MEM_CACHE_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_GLOBAL_MEM_SIZE,
                         sizeof(cl_ulong),
                         &globalMemSize,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_GLOBAL_MEM_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE,
                         sizeof(cl_ulong),
                         &maxConstBufSize,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_MAX_CONSTANT_ARGS,
                         sizeof(cl_uint),
                         &maxConstArgs,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_MAX_CONSTANT_ARGS) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_LOCAL_MEM_TYPE,
                         sizeof(cl_device_local_mem_type),
                         &localMemType,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_LOCAL_MEM_TYPE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_LOCAL_MEM_SIZE,
                         sizeof(cl_ulong),
                         &localMemSize,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_LOCAL_MEM_SIZE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_ERROR_CORRECTION_SUPPORT,
                         sizeof(cl_bool),
                         &errCorrectionSupport,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_ERROR_CORRECTION_SUPPORT) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PROFILING_TIMER_RESOLUTION,
                         sizeof(size_t),
                         &timerResolution,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_PROFILING_TIMER_RESOLUTION) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_ENDIAN_LITTLE,
                         sizeof(cl_bool),
                         &endianLittle,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_ENDIAN_LITTLE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_AVAILABLE,
                         sizeof(cl_bool),
                         &available,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_AVAILABLE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_COMPILER_AVAILABLE,
                         sizeof(cl_bool),
                         &compilerAvailable,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_COMPILER_AVAILABLE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_EXECUTION_CAPABILITIES,
                         sizeof(cl_device_exec_capabilities),
                         &execCapabilities,
                         NULL);
            CHECK_OPENCL_ERROR(status,
                               "clGetDeviceIDs(CL_DEVICE_EXECUTION_CAPABILITIES) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_QUEUE_PROPERTIES,
                         sizeof(cl_command_queue_properties),
                         &queueProperties,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_QUEUE_PROPERTIES) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PLATFORM,
                         sizeof(cl_platform_id),
                         &platform,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_PLATFORM) failed");
            
            size_t tempSize = 0;
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_NAME,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_NAME) failed");
            delete name;
            name = new char[tempSize];
            CHECK_ALLOCATION(name, "Failed to allocate memory(name)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_NAME,
                         sizeof(char) * tempSize,
                         name,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_NAME) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_VENDOR,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_VENDOR) failed");
            delete vendorName;
            vendorName = new char[tempSize];
            CHECK_ALLOCATION(vendorName, "Failed to allocate memory(venderName)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_VENDOR,
                         sizeof(char) * tempSize,
                         vendorName,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_VENDOR) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DRIVER_VERSION,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DRIVER_VERSION) failed");
            delete driverVersion;
            driverVersion = new char[tempSize];
            CHECK_ALLOCATION(driverVersion, "Failed to allocate memory(driverVersion)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DRIVER_VERSION,
                         sizeof(char) * tempSize,
                         driverVersion,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DRIVER_VERSION) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PROFILE,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_PROFILE) failed");
            delete profileType;
            profileType = new char[tempSize];
            CHECK_ALLOCATION(profileType, "Failed to allocate memory(profileType)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_PROFILE,
                         sizeof(char) * tempSize,
                         profileType,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_PROFILE) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_VERSION,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_VERSION) failed");
            delete deviceVersion;
            deviceVersion = new char[tempSize];
            CHECK_ALLOCATION(deviceVersion, "Failed to allocate memory(deviceVersion)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_VERSION,
                         sizeof(char) * tempSize,
                         deviceVersion,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_VERSION) failed");
            
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_EXTENSIONS,
                         0,
                         NULL,
                         &tempSize);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_EXTENSIONS) failed");
            delete extensions;
            extensions = new char[tempSize];
            CHECK_ALLOCATION(extensions, "Failed to allocate memory(extensions)");
            status = clGetDeviceInfo(
                         deviceId,
                         CL_DEVICE_EXTENSIONS,
                         sizeof(char) * tempSize,
                         extensions,
                         NULL);
            CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_EXTENSIONS) failed");
            
#ifdef CL_VERSION_1_1
            std::string deviceVerStr(deviceVersion);
            size_t vStart = deviceVerStr.find(" ", 0);
            size_t vEnd = deviceVerStr.find(" ", vStart + 1);
            std::string vStrVal = deviceVerStr.substr(vStart + 1, vEnd - vStart - 1);
            if(vStrVal.compare("1.0") > 0)
            {
                
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR,
                             sizeof(cl_uint),
                             &nativeCharVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT,
                             sizeof(cl_uint),
                             &nativeShortVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_INT,
                             sizeof(cl_uint),
                             &nativeIntVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_INT) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG,
                             sizeof(cl_uint),
                             &nativeLongVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT,
                             sizeof(cl_uint),
                             &nativeFloatVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE,
                             sizeof(cl_uint),
                             &nativeDoubleVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE) failed");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF,
                             sizeof(cl_uint),
                             &nativeHalfVecWidth,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF) failed");
                
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_HOST_UNIFIED_MEMORY,
                             sizeof(cl_bool),
                             &hostUnifiedMem,
                             NULL);
                CHECK_OPENCL_ERROR(status,
                                   "clGetDeviceIDs(CL_DEVICE_HOST_UNIFIED_MEMORY) failed");
                
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_OPENCL_C_VERSION,
                             0,
                             NULL,
                             &tempSize);
                CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_OPENCL_C_VERSION) failed");
                delete openclCVersion;
                openclCVersion = new char[tempSize];
                CHECK_ALLOCATION(openclCVersion, "Failed to allocate memory(openclCVersion)");
                status = clGetDeviceInfo(
                             deviceId,
                             CL_DEVICE_OPENCL_C_VERSION,
                             sizeof(char) * tempSize,
                             openclCVersion,
                             NULL);
                CHECK_OPENCL_ERROR(status, "clGetDeviceIDs(CL_DEVICE_OPENCL_C_VERSION) failed");
            }
#endif
            return SDK_SUCCESS;
        }
    private :

        
        template<typename T>
        int checkVal(T input, T reference, std::string message,
                     bool isAPIerror = true) const
        {
            if(input==reference)
            {
                return 0;
            }
            else
            {
                if(isAPIerror)
                {
                    std::cout<<"Error: "<< message << " Error code : ";
                    std::cout << getOpenCLErrorCodeStr(input) << std::endl;
                }
                else
                {
                    std::cout << message;
                }
                return 1;
            }
        }

};

}
#endif


