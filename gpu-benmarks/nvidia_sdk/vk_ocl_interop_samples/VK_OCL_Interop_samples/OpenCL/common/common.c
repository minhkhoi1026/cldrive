#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>

#include "common.h"

                                                 
/*
 * __TEMP_WAR__ : Waive dse and svm related tests on failing configs.
 * TODO: Fix dse and svm related test failures, bug: 200233879.
 */
#define WAIVED_STRING_COUNT 5                                                
const char *waived_string_names[WAIVED_STRING_COUNT] = {"TITAN V",
                                                        "RTX",
                                                        "V100",
                                                        "T4",
                                                        "Graphics Device"};

//openCL version check
cl_bool isOpenCLVersion_1_1_OrHigher(cl_platform_id* platform)
{
    size_t openCLVersionSize;   
    char *openCLVersion, *substringOpenCL;
    cl_int err = CL_SUCCESS;
    cl_bool ret;

    err = clGetPlatformInfo(*platform, CL_PLATFORM_VERSION, 0, NULL, &openCLVersionSize);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get platform info!\n");
        assert(!err);
    }
    openCLVersion = (char*)malloc(sizeof(char)*openCLVersionSize);
    err = clGetPlatformInfo(*platform, CL_PLATFORM_VERSION, openCLVersionSize, openCLVersion, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get platform info!\n");
        assert(!err);
    }
    substringOpenCL = strstr(openCLVersion, "OpenCL");
    //7th and 9th characters gives major and minor versions
    if (substringOpenCL[7] >= '1' && substringOpenCL[9] >= '1') {
        ret = CL_TRUE;
    } else {
        printf("This app requires OpenCL version 1.1 or higher, found %s\n", openCLVersion);
        ret = CL_FALSE;
    }
    free(openCLVersion);
    return ret;
}

// Compute Capability
cl_int isComputeCapabilityAtLeast(cl_device_id device, cl_uint major, cl_uint minor, cl_bool* result) {

    char * device_string = NULL;
    cl_int err;
    size_t size = 0;
    *result = CL_FALSE;

    err = clGetDeviceInfo(device, CL_DEVICE_EXTENSIONS, 0, NULL, &size);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get device extensions size\n");
        goto Error;
    }
    device_string = (char *)malloc(sizeof(char)*(size+1));
    if (device_string == NULL) {
        err = CL_OUT_OF_HOST_MEMORY;
        printf("Error: Failed to allocate memory for device extn query\n");
        goto Error;
    }
    memset(device_string, 0, sizeof(char)*(size+1));

    err = clGetDeviceInfo(device, CL_DEVICE_EXTENSIONS, sizeof(char)*size, device_string, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get device extensions\n");
        goto Error;
    }

    // set the last char null to avoid issues with string functions
    *(device_string +size) = '\0';

    if (device_string != NULL && strstr(device_string, "cl_nv_device_attribute_query")) {
        cl_uint compute_capability_major, compute_capability_minor;
        err = clGetDeviceInfo(device, CL_DEVICE_COMPUTE_CAPABILITY_MAJOR_NV, sizeof(cl_uint), &compute_capability_major, NULL);
        if(err != CL_SUCCESS) {
            printf("Error: Failed to get device compute capability major\n");
            goto Error;
        }
        err = clGetDeviceInfo(device, CL_DEVICE_COMPUTE_CAPABILITY_MINOR_NV, sizeof(cl_uint), &compute_capability_minor, NULL);
        if (err != CL_SUCCESS) {
            printf("Error: Failed to get device compute capability minor\n");
            goto Error;
        }

        if ((compute_capability_major == major && compute_capability_minor >=minor)|| 
            compute_capability_major > major) {
            *result = CL_TRUE;
        }
    }
    else {
        printf("Device does not support cl_nv_device_attribute_query\n");
        err = CL_INVALID_VALUE;
    }

Error:
    free(device_string);
    return err;
}

cl_int nvDriverSupportsCL12Plus(cl_device_id device, cl_bool* result) {

    char * vendor_string = NULL;
    char * driver_version_string = NULL;
    cl_uint major = 0, minor = 0;
    cl_int err = CL_SUCCESS;
    size_t size = 0;
    char c = 0;

    *result = CL_FALSE;

    // Get Vendor Name
    err = clGetDeviceInfo(device, CL_DEVICE_VENDOR, 0, NULL, &size);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get device vendor string size\n");
        goto Error;
    }
    vendor_string = (char *)malloc(sizeof(char)*(size+1));
    if (vendor_string == NULL) {
        err = CL_OUT_OF_HOST_MEMORY;
        printf("Error: Failed to allocate memory for device vendor query\n");
        goto Error;
    }
    memset(vendor_string, 0, sizeof(char)*(size+1));

    err = clGetDeviceInfo(device, CL_DEVICE_VENDOR, sizeof(char)*size, vendor_string, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get device vendor\n");
        goto Error;
    }
    vendor_string[size] = '\0';
    if (!strstr(vendor_string,"NVIDIA")) {
        *result = CL_FALSE;
        goto Error;
    }

    // Get Driver Version
    err = clGetDeviceInfo(device, CL_DRIVER_VERSION, 0, NULL, &size);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get driver version string size\n");
        goto Error;
    }
    driver_version_string = (char *)malloc(sizeof(char)*(size+1));
    if (driver_version_string == NULL) {
        err = CL_OUT_OF_HOST_MEMORY;
        printf("Error: Failed to allocate memory for device extn query\n");
        goto Error;
    }
    memset(driver_version_string, 0, sizeof(char)*(size+1));

    err = clGetDeviceInfo(device, CL_DRIVER_VERSION, sizeof(char)*size, driver_version_string, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get driver version \n");
        goto Error;
    }
    driver_version_string[size] = '\0';

    sscanf(driver_version_string,"%d%c%d",&major,&c,&minor);

    // 1.2+ supported in EA branch (OC353_43) and 367.00 onwards
    if (((major == 353 && minor >= 43 )||( major > 353 && major < 355)) ||
        (major >= 378)) {
        *result = CL_TRUE;
    }
    else {
        *result = CL_FALSE;
    }

Error:
    free(vendor_string);
    free(driver_version_string);
    return err;
}

// Check if the test is to be waived on current device
cl_int isCurrentDeviceWaived(cl_device_id device, cl_bool* result)
{
	cl_int err = CL_SUCCESS, i;
	char cDevName[1024];
    *result = CL_FALSE;
    err = clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(cDevName), &cDevName, NULL);
	if ( err == CL_SUCCESS ) {
	    for ( i = 0 ; i < WAIVED_STRING_COUNT ; i++ ) {
	        if ( strstr(cDevName, waived_string_names[i]) ) {
	            *result = CL_TRUE;
                break;
        	}
    	}
	}
	return err;
}

cl_bool isConfigMultiGpu(size_t size) {
	int numDevices = 0;
    numDevices = size/sizeof(cl_device_id);
    if (numDevices > 1) {
		return CL_TRUE;
	}
	else {
		return CL_FALSE;
	}
}
