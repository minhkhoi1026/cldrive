




#ifndef __CL_EXT_H
#define __CL_EXT_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __APPLE__
    #include <OpenCL/cl.h>
    #include <AvailabilityMacros.h>
#else
    #include <CL/cl.h>
#endif



#define CL_DEVICE_DOUBLE_FP_CONFIG                  0x1032


#define CL_DEVICE_HALF_FP_CONFIG                    0x1033


#define cl_APPLE_SetMemObjectDestructor 1
cl_int  CL_API_ENTRY clSetMemObjectDestructorAPPLE(  cl_mem memobj,
                                        void (* pfn_notify)(cl_mem memobj, void * user_data),
                                        void * user_data)             CL_EXT_SUFFIX__VERSION_1_0;



#define cl_APPLE_ContextLoggingFunctions 1
extern void CL_API_ENTRY clLogMessagesToSystemLogAPPLE(  const char * errstr,
                                            const void * private_info,
                                            size_t       cb,
                                            void *       user_data)  CL_EXT_SUFFIX__VERSION_1_0;


extern void CL_API_ENTRY clLogMessagesToStdoutAPPLE(   const char * errstr,
                                          const void * private_info,
                                          size_t       cb,
                                          void *       user_data)    CL_EXT_SUFFIX__VERSION_1_0;


extern void CL_API_ENTRY clLogMessagesToStderrAPPLE(   const char * errstr,
                                          const void * private_info,
                                          size_t       cb,
                                          void *       user_data)    CL_EXT_SUFFIX__VERSION_1_0;



#define cl_khr_icd 1


#define CL_PLATFORM_ICD_SUFFIX_KHR                  0x0920


#define CL_PLATFORM_NOT_FOUND_KHR                   -1001

extern CL_API_ENTRY cl_int CL_API_CALL
clIcdGetPlatformIDsKHR(cl_uint          num_entries,
                       cl_platform_id * platforms,
                       cl_uint *        num_platforms);

typedef CL_API_ENTRY cl_int
(CL_API_CALL *clIcdGetPlatformIDsKHR_fn)(cl_uint          num_entries,
                                         cl_platform_id * platforms,
                                         cl_uint *        num_platforms);



#define cl_khr_il_program 1


#define CL_DEVICE_IL_VERSION_KHR                    0x105B


#define CL_PROGRAM_IL_KHR                           0x1169

extern CL_API_ENTRY cl_program CL_API_CALL
clCreateProgramWithILKHR(cl_context   context,
                         const void * il,
                         size_t       length,
                         cl_int *     errcode_ret);

typedef CL_API_ENTRY cl_program
(CL_API_CALL *clCreateProgramWithILKHR_fn)(cl_context   context,
                                           const void * il,
                                           size_t       length,
                                           cl_int *     errcode_ret) CL_EXT_SUFFIX__VERSION_1_2;



#define CL_DEVICE_IMAGE_PITCH_ALIGNMENT_KHR              0x104A
#define CL_DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT_KHR       0x104B




#define CL_CONTEXT_MEMORY_INITIALIZE_KHR            0x2030




#define CL_CONTEXT_TERMINATED_KHR                   -1121

#define CL_DEVICE_TERMINATE_CAPABILITY_KHR          0x2031
#define CL_CONTEXT_TERMINATE_KHR                    0x2032

#define cl_khr_terminate_context 1
extern CL_API_ENTRY cl_int CL_API_CALL
clTerminateContextKHR(cl_context context) CL_EXT_SUFFIX__VERSION_1_2;

typedef CL_API_ENTRY cl_int
(CL_API_CALL *clTerminateContextKHR_fn)(cl_context context) CL_EXT_SUFFIX__VERSION_1_2;




#define CL_DEVICE_SPIR_VERSIONS                     0x40E0
#define CL_PROGRAM_BINARY_TYPE_INTERMEDIATE         0x40E1



#define cl_khr_create_command_queue 1

typedef cl_properties cl_queue_properties_khr;

extern CL_API_ENTRY cl_command_queue CL_API_CALL
clCreateCommandQueueWithPropertiesKHR(cl_context context,
                                      cl_device_id device,
                                      const cl_queue_properties_khr* properties,
                                      cl_int* errcode_ret) CL_EXT_SUFFIX__VERSION_1_2;

typedef CL_API_ENTRY cl_command_queue
(CL_API_CALL *clCreateCommandQueueWithPropertiesKHR_fn)(cl_context context,
                                                        cl_device_id device,
                                                        const cl_queue_properties_khr* properties,
                                                        cl_int* errcode_ret) CL_EXT_SUFFIX__VERSION_1_2;




typedef enum _cl_semaphore_type__enum {
    CL_SEMAPHORE_TYPE_BINARY        = 1,
} cl_semaphore_type;

typedef cl_properties cl_semaphore_properties_khr;

typedef cl_uint cl_semaphore_info;

typedef struct _cl_semaphore* cl_semaphore_khr;
typedef cl_ulong cl_semaphore_payload;

extern CL_API_ENTRY cl_semaphore_khr CL_API_CALL
clCreateSemaphoreWithPropertiesKHR(cl_context context,
                                   cl_semaphore_properties_khr *sema_props,
                                   cl_int *errcode_ret) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueWaitSemaphoresKHR(cl_command_queue command_queue,
                              cl_uint num_sema_objects,
                              const cl_semaphore_khr *sema_objects,
                              const cl_semaphore_payload *sema_payload_list,
                              cl_uint num_events_in_wait_list,
                              const cl_event *event_wait_list,
                              cl_event *event) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSignalSemaphoresKHR(cl_command_queue command_queue,
                             cl_uint num_sema_objects,
                             const cl_semaphore_khr *sema_objects,
                             const cl_semaphore_payload *sema_payload_list,
                             cl_uint num_events_in_wait_list,
                             const cl_event *event_wait_list,
                             cl_event *event) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clGetSemaphoreInfoKHR(const cl_semaphore_khr sema_object,
                      cl_semaphore_info param_name,
                      size_t param_value_size,
                      void *param_value,
                      size_t *param_value_size_ret) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clReleaseSemaphoreKHR(cl_semaphore_khr sema_object) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clRetainSemaphoreKHR(cl_semaphore_khr sema_object) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clReleaseSemaphoreObjectKHR(cl_semaphore_khr sema_object)  CL_API_SUFFIX__VERSION_1_2;

#define CL_COMMAND_SEMAPHORE_WAIT_KHR               0x2050
#define CL_COMMAND_SEMAPHORE_SIGNAL_KHR             0x2051
#define CL_SEMAPHORE_CONTEXT_KHR                    0x2452
#define CL_SEMAPHORE_REFERENCE_COUNT_KHR            0x2453
#define CL_SEMAPHORE_PROPERTIES_KHR                 0x2454
#define CL_SEMAPHORE_TYPE_KHR                       0x2455
#define CL_PLATFORM_SEMAPHORE_TYPES_KHR             0x2456
#define CL_SEMAPHORE_PAYLOAD_KHR                    0x2457



typedef enum _cl_external_context_type_enum {
    CL_EXTERNAL_CONTEXT_TYPE_NONE       = 0,
    CL_EXTERNAL_CONTEXT_TYPE_CL         = 1,
    CL_EXTERNAL_CONTEXT_TYPE_VULKAN     = 2,
} cl_external_context_type_khr;

typedef cl_uint cl_external_semaphore_handle_type_khr;

#define CL_SEMAPHORE_HANDLE_OPAQUE_FD_KHR                      0x2055
#define CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KHR                   0x2056
#define CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KMT_KHR               0x2057

typedef struct _cl_semaphore_desc_khr_st {
    cl_external_semaphore_handle_type_khr type;
    void *handle_ptr;
} cl_semaphore_desc_khr;

extern CL_API_ENTRY cl_int CL_API_CALL
clGetSemaphoreHandleForTypeKHR(
    const cl_semaphore_khr sema_object,
    const cl_device_id device,
    cl_external_semaphore_handle_type_khr handleType,
    void *handle,
    size_t *handleSize) CL_API_SUFFIX__VERSION_1_2;
    

#define CL_SEMAPHORE_DESC_KHR                                   0x2460
#define CL_SEMAPHORE_EXPORT_HANDLE_TYPES_KHR                    0x203F

#define CL_PLATFORM_SEMAPHORE_IMPORT_HANDLE_TYPES_KHR           0x2461
#define CL_PLATFORM_SEMAPHORE_EXPORT_HANDLE_TYPES_KHR           0x2038

#define CL_DEVICE_SEMAPHORE_IMPORT_HANDLE_TYPES_KHR                         0x204D
#define CL_DEVICE_SEMAPHORE_EXPORT_HANDLE_TYPES_KHR                         0x204E


#define CL_INVALID_SEMAPHORE_KHR                                -1142



typedef cl_uint cl_external_context_info;

typedef enum _cl_external_context_type_enum cl_external_context_type_khr;

typedef cl_properties cl_mem_properties_khr;

typedef cl_uint cl_external_mem_handle_type_khr;

#define CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_FD_KHR            0x2060
#define CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KHR         0x2061
#define CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KMT_KHR     0x2062

typedef struct _cl_external_mem_desc_khr_st {
    cl_external_mem_handle_type_khr type;
    void *handle_ptr;
    size_t offset;
    unsigned long long size;
} cl_external_mem_desc_khr;

extern CL_API_ENTRY cl_int CL_API_CALL
clGetExternalContextInfoKHR(const cl_context_properties  *properties,
                            cl_external_context_info  param_name,   
                            size_t  param_value_size,
                            void  *param_value,
                            size_t  *param_value_size_ret) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueAcquireExternalMemObjectsKHR(cl_command_queue command_queue, 
                                      cl_uint num_mem_objects,
                                      const cl_mem *mem_objects,
                                      cl_uint num_events_in_wait_list,
                                      const cl_event *event_wait_list,
                                      cl_event *event) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueReleaseExternalMemObjectsKHR(cl_command_queue command_queue,
                                      cl_uint num_mem_objects,
                                      const cl_mem *mem_objects,
                                      cl_uint num_events_in_wait_list,
                                      const cl_event *event_wait_list,
                                      cl_event *event) CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateBufferFromExternalMemoryKHR(cl_context context,
                                    const cl_mem_properties_khr* properties,
                                    cl_mem_flags flags,
                                    cl_external_mem_desc_khr extMem,
                                    cl_int *errcode_ret)  CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateImageFromExternalMemoryKHR(cl_context context,
                                   const cl_mem_properties_khr* properties,
                                   cl_mem_flags flags,
                                   cl_external_mem_desc_khr extMem,
                                   const cl_image_format *image_format,
                                   const cl_image_desc *image_desc,
                                   cl_int *errcode_ret)  CL_API_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_semaphore_khr CL_API_CALL
clCreateFromExternalSemaphoreKHR(cl_context context,
                                 cl_semaphore_properties_khr *sema_props,
                                 cl_semaphore_desc_khr sema_desc,
                                 cl_int *errcode_ret)  
                                 CL_API_SUFFIX__VERSION_1_2;

#define CL_INVALID_EXTERNAL_DEVICEGROUP_REFERENCE_KHR   -1122
#define CL_INVALID_EXT_MEM_DESC_KHR                     -1123
#define CL_INVALID_EXT_MEM_HANDLE_TYPE_KHR              -1148
#define CL_INVALID_EXT_MEM_HANDLE_KHR                   -1149
#define CL_INVALID_EXT_MEM_OFFSET_KHR                   -1150
#define CL_INVALID_EXT_MEM_SIZE_KHR                     -1140

#define CL_CURRENT_DEVICE_FOR_EXTERNAL_CONTEXT_KHR      0x2036
#define CL_DEVICES_FOR_EXTERNAL_CONTEXT_KHR             0x2037
#define CL_EXTERNAL_DEVICE_KHR                          0x2038
#define CL_EXTERNAL_DEVICEGROUP_KHR                     0x2039
#define CL_EXTERNAL_CONTEXT_TYPE_KHR                    0x204B
#define CL_DEVICE_HANDLE_LIST_KHR                       0x2051
#define CL_DEVICE_HANDLE_LIST_END_KHR                   0x2052


#define CL_COMMAND_ACQUIRE_EXTERNAL_MEM_OBJECTS_KHR     0x203A
#define CL_COMMAND_RELEASE_EXTERNAL_MEM_OBJECTS_KHR     0x203B
#define CL_EXTERNAL_MEM_DESC_KHR                        0x203C
#define CL_EXTERNAL_IMAGE_INFO_KHR                      0x203D
#define CL_PLATFORM_EXTERNAL_HANDLE_TYPES_KHR           0x203E
#define CL_PLATFORM_EXTERNAL_MEMORY_IMPORT_HANDLE_TYPES_KHR  0x2044
#define CL_DEVICE_EXTERNAL_MEMORY_IMPORT_HANDLE_TYPES_KHR    0x204F
#define CL_DEVICE_EXTERNAL_MEMORY_PROPERTIES_KHR             0x2050





#define CL_DEVICE_COMPUTE_CAPABILITY_MAJOR_NV       0x4000
#define CL_DEVICE_COMPUTE_CAPABILITY_MINOR_NV       0x4001
#define CL_DEVICE_REGISTERS_PER_BLOCK_NV            0x4002
#define CL_DEVICE_WARP_SIZE_NV                      0x4003
#define CL_DEVICE_GPU_OVERLAP_NV                    0x4004
#define CL_DEVICE_KERNEL_EXEC_TIMEOUT_NV            0x4005
#define CL_DEVICE_INTEGRATED_MEMORY_NV              0x4006
#define CL_DEVICE_ATTRIBUTE_ASYNC_ENGINE_COUNT_NV   0x4007
#define CL_DEVICE_PCI_BUS_ID_NV                     0x4008
#define CL_DEVICE_PCI_SLOT_ID_NV                    0x4009
#define CL_DEVICE_PCI_DOMAIN_ID_NV                  0x400A
#define CL_DEVICE_MAX_LOCAL_MEMORY_PER_SM_NV        0x400B
#define CL_DEVICE_UUID_KHR                          0x106A 
#define CL_DRIVER_UUID_KHR                          0x106B    
#define CL_DEVICE_LUID_VALID_KHR                    0x106C     
#define CL_DEVICE_LUID_KHR                          0x106D     
#define CL_DEVICE_NODE_MASK_KHR                     0x106E     
#define CL_UUID_SIZE_KHR                            16
#define CL_LUID_SIZE_KHR                            8



typedef cl_bitfield         cl_mem_flags_NV;
CL_API_ENTRY cl_mem CL_API_CALL
clCreateBufferNV(cl_context     context,
               cl_mem_flags     flags,
               cl_mem_flags_NV  flags_NV,
               size_t           size,
               void             *host_ptr,
               cl_int           *errcode_ret);



typedef enum kernel_attribute_enum {
    CL_KERNEL_PREFERRED_LOCAL_MEMORY_SIZE_NV = 0,   
} cl_kernel_attribute_nv;

CL_API_ENTRY cl_int CL_API_CALL
clSetKernelAttributeNV(cl_kernel kernel,
                       cl_device_id device,
                       cl_kernel_attribute_nv k_attr,
                       size_t param_value_size,
                       const void *param_value);

CL_API_ENTRY cl_int CL_API_CALL
clGetKernelAttributeNV(cl_kernel kernel,
                       cl_device_id device,
                       cl_kernel_attribute_nv k_attr,
                       size_t param_value_size,
                       void *param_value,
                       size_t *param_value_size_ret);

#define CL_MEM_LOCATION_HOST_NV                     (1 << 0)
#define CL_MEM_PINNED_NV                            (1 << 1)



#define CL_DEVICE_PROFILING_TIMER_OFFSET_AMD            0x4036
#define CL_DEVICE_TOPOLOGY_AMD                          0x4037
#define CL_DEVICE_BOARD_NAME_AMD                        0x4038
#define CL_DEVICE_GLOBAL_FREE_MEMORY_AMD                0x4039
#define CL_DEVICE_SIMD_PER_COMPUTE_UNIT_AMD             0x4040
#define CL_DEVICE_SIMD_WIDTH_AMD                        0x4041
#define CL_DEVICE_SIMD_INSTRUCTION_WIDTH_AMD            0x4042
#define CL_DEVICE_WAVEFRONT_WIDTH_AMD                   0x4043
#define CL_DEVICE_GLOBAL_MEM_CHANNELS_AMD               0x4044
#define CL_DEVICE_GLOBAL_MEM_CHANNEL_BANKS_AMD          0x4045
#define CL_DEVICE_GLOBAL_MEM_CHANNEL_BANK_WIDTH_AMD     0x4046
#define CL_DEVICE_LOCAL_MEM_SIZE_PER_COMPUTE_UNIT_AMD   0x4047
#define CL_DEVICE_LOCAL_MEM_BANKS_AMD                   0x4048
#define CL_DEVICE_THREAD_TRACE_SUPPORTED_AMD            0x4049
#define CL_DEVICE_GFXIP_MAJOR_AMD                       0x404A
#define CL_DEVICE_GFXIP_MINOR_AMD                       0x404B
#define CL_DEVICE_AVAILABLE_ASYNC_QUEUES_AMD            0x404C
#define CL_DEVICE_PREFERRED_WORK_GROUP_SIZE_AMD         0x4030
#define CL_DEVICE_MAX_WORK_GROUP_SIZE_AMD               0x4031
#define CL_DEVICE_PREFERRED_CONSTANT_BUFFER_SIZE_AMD    0x4033
#define CL_DEVICE_PCIE_ID_AMD                           0x4034




#define CL_PRINTF_CALLBACK_ARM                      0x40B0
#define CL_PRINTF_BUFFERSIZE_ARM                    0x40B1



#define cl_ext_device_fission   1

extern CL_API_ENTRY cl_int CL_API_CALL
clReleaseDeviceEXT(cl_device_id device) CL_EXT_SUFFIX__VERSION_1_1;

typedef CL_API_ENTRY cl_int
(CL_API_CALL *clReleaseDeviceEXT_fn)(cl_device_id device) CL_EXT_SUFFIX__VERSION_1_1;

extern CL_API_ENTRY cl_int CL_API_CALL
clRetainDeviceEXT(cl_device_id device) CL_EXT_SUFFIX__VERSION_1_1;

typedef CL_API_ENTRY cl_int
(CL_API_CALL *clRetainDeviceEXT_fn)(cl_device_id device) CL_EXT_SUFFIX__VERSION_1_1;

typedef cl_ulong  cl_device_partition_property_ext;
extern CL_API_ENTRY cl_int CL_API_CALL
clCreateSubDevicesEXT(cl_device_id   in_device,
                      const cl_device_partition_property_ext * properties,
                      cl_uint        num_entries,
                      cl_device_id * out_devices,
                      cl_uint *      num_devices) CL_EXT_SUFFIX__VERSION_1_1;

typedef CL_API_ENTRY cl_int
(CL_API_CALL * clCreateSubDevicesEXT_fn)(cl_device_id   in_device,
                                         const cl_device_partition_property_ext * properties,
                                         cl_uint        num_entries,
                                         cl_device_id * out_devices,
                                         cl_uint *      num_devices) CL_EXT_SUFFIX__VERSION_1_1;


#define CL_DEVICE_PARTITION_EQUALLY_EXT             0x4050
#define CL_DEVICE_PARTITION_BY_COUNTS_EXT           0x4051
#define CL_DEVICE_PARTITION_BY_NAMES_EXT            0x4052
#define CL_DEVICE_PARTITION_BY_AFFINITY_DOMAIN_EXT  0x4053


#define CL_DEVICE_PARENT_DEVICE_EXT                 0x4054
#define CL_DEVICE_PARTITION_TYPES_EXT               0x4055
#define CL_DEVICE_AFFINITY_DOMAINS_EXT              0x4056
#define CL_DEVICE_REFERENCE_COUNT_EXT               0x4057
#define CL_DEVICE_PARTITION_STYLE_EXT               0x4058


#define CL_DEVICE_PARTITION_FAILED_EXT              -1057
#define CL_INVALID_PARTITION_COUNT_EXT              -1058
#define CL_INVALID_PARTITION_NAME_EXT               -1059


#define CL_AFFINITY_DOMAIN_L1_CACHE_EXT             0x1
#define CL_AFFINITY_DOMAIN_L2_CACHE_EXT             0x2
#define CL_AFFINITY_DOMAIN_L3_CACHE_EXT             0x3
#define CL_AFFINITY_DOMAIN_L4_CACHE_EXT             0x4
#define CL_AFFINITY_DOMAIN_NUMA_EXT                 0x10
#define CL_AFFINITY_DOMAIN_NEXT_FISSIONABLE_EXT     0x100


#define CL_PROPERTIES_LIST_END_EXT                  ((cl_device_partition_property_ext) 0)
#define CL_PARTITION_BY_COUNTS_LIST_END_EXT         ((cl_device_partition_property_ext) 0)
#define CL_PARTITION_BY_NAMES_LIST_END_EXT          ((cl_device_partition_property_ext) 0 - 1)



#define cl_ext_migrate_memobject 1

typedef cl_bitfield cl_mem_migration_flags_ext;

#define CL_MIGRATE_MEM_OBJECT_HOST_EXT              0x1

#define CL_COMMAND_MIGRATE_MEM_OBJECT_EXT           0x4040

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueMigrateMemObjectEXT(cl_command_queue command_queue,
                             cl_uint          num_mem_objects,
                             const cl_mem *   mem_objects,
                             cl_mem_migration_flags_ext flags,
                             cl_uint          num_events_in_wait_list,
                             const cl_event * event_wait_list,
                             cl_event *       event);

typedef CL_API_ENTRY cl_int
(CL_API_CALL *clEnqueueMigrateMemObjectEXT_fn)(cl_command_queue command_queue,
                                               cl_uint          num_mem_objects,
                                               const cl_mem *   mem_objects,
                                               cl_mem_migration_flags_ext flags,
                                               cl_uint          num_events_in_wait_list,
                                               const cl_event * event_wait_list,
                                               cl_event *       event);



#define cl_ext_cxx_for_opencl 1

#define CL_DEVICE_CXX_FOR_OPENCL_NUMERIC_VERSION_EXT 0x4230


#define cl_qcom_ext_host_ptr 1

#define CL_MEM_EXT_HOST_PTR_QCOM                  (1 << 29)

#define CL_DEVICE_EXT_MEM_PADDING_IN_BYTES_QCOM   0x40A0
#define CL_DEVICE_PAGE_SIZE_QCOM                  0x40A1
#define CL_IMAGE_ROW_ALIGNMENT_QCOM               0x40A2
#define CL_IMAGE_SLICE_ALIGNMENT_QCOM             0x40A3
#define CL_MEM_HOST_UNCACHED_QCOM                 0x40A4
#define CL_MEM_HOST_WRITEBACK_QCOM                0x40A5
#define CL_MEM_HOST_WRITETHROUGH_QCOM             0x40A6
#define CL_MEM_HOST_WRITE_COMBINING_QCOM          0x40A7

typedef cl_uint                                   cl_image_pitch_info_qcom;

extern CL_API_ENTRY cl_int CL_API_CALL
clGetDeviceImageInfoQCOM(cl_device_id             device,
                         size_t                   image_width,
                         size_t                   image_height,
                         const cl_image_format   *image_format,
                         cl_image_pitch_info_qcom param_name,
                         size_t                   param_value_size,
                         void                    *param_value,
                         size_t                  *param_value_size_ret);

typedef struct _cl_mem_ext_host_ptr
{
    
    
    cl_uint  allocation_type;

    
    cl_uint  host_cache_policy;

} cl_mem_ext_host_ptr;





#define CL_MEM_HOST_IOCOHERENT_QCOM               0x40A9




#define CL_MEM_ION_HOST_PTR_QCOM                  0x40A8

typedef struct _cl_mem_ion_host_ptr
{
    
    
    cl_mem_ext_host_ptr  ext_host_ptr;

    
    int                  ion_filedesc;

    
    void*                ion_hostptr;

} cl_mem_ion_host_ptr;




#define CL_MEM_ANDROID_NATIVE_BUFFER_HOST_PTR_QCOM                  0x40C6

typedef struct _cl_mem_android_native_buffer_host_ptr
{
    
    
    cl_mem_ext_host_ptr  ext_host_ptr;

    
    void*                anb_ptr;

} cl_mem_android_native_buffer_host_ptr;





#define CL_NV21_IMG                                 0x40D0
#define CL_YV12_IMG                                 0x40D1





#define CL_MEM_USE_UNCACHED_CPU_MEMORY_IMG          (1 << 26)
#define CL_MEM_USE_CACHED_CPU_MEMORY_IMG            (1 << 27)



#define cl_img_use_gralloc_ptr 1


#define CL_MEM_USE_GRALLOC_PTR_IMG                  (1 << 28)


#define CL_COMMAND_ACQUIRE_GRALLOC_OBJECTS_IMG      0x40D2
#define CL_COMMAND_RELEASE_GRALLOC_OBJECTS_IMG      0x40D3


#define CL_GRALLOC_RESOURCE_NOT_ACQUIRED_IMG        0x40D4

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueAcquireGrallocObjectsIMG(cl_command_queue      command_queue,
                                  cl_uint               num_objects,
                                  const cl_mem *        mem_objects,
                                  cl_uint               num_events_in_wait_list,
                                  const cl_event *      event_wait_list,
                                  cl_event *            event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueReleaseGrallocObjectsIMG(cl_command_queue      command_queue,
                                  cl_uint               num_objects,
                                  const cl_mem *        mem_objects,
                                  cl_uint               num_events_in_wait_list,
                                  const cl_event *      event_wait_list,
                                  cl_event *            event) CL_EXT_SUFFIX__VERSION_1_2;



#define cl_khr_subgroups 1

#if !defined(CL_VERSION_2_1)

typedef cl_uint             cl_kernel_sub_group_info;
#endif


#define CL_KERNEL_MAX_SUB_GROUP_SIZE_FOR_NDRANGE_KHR    0x2033
#define CL_KERNEL_SUB_GROUP_COUNT_FOR_NDRANGE_KHR       0x2034

extern CL_API_ENTRY cl_int CL_API_CALL
clGetKernelSubGroupInfoKHR(cl_kernel    in_kernel,
                           cl_device_id in_device,
                           cl_kernel_sub_group_info param_name,
                           size_t       input_value_size,
                           const void * input_value,
                           size_t       param_value_size,
                           void *       param_value,
                           size_t *     param_value_size_ret) CL_EXT_SUFFIX__VERSION_2_0_DEPRECATED;

typedef CL_API_ENTRY cl_int
(CL_API_CALL * clGetKernelSubGroupInfoKHR_fn)(cl_kernel    in_kernel,
                                              cl_device_id in_device,
                                              cl_kernel_sub_group_info param_name,
                                              size_t       input_value_size,
                                              const void * input_value,
                                              size_t       param_value_size,
                                              void *       param_value,
                                              size_t *     param_value_size_ret) CL_EXT_SUFFIX__VERSION_2_0_DEPRECATED;





#define CL_SAMPLER_MIP_FILTER_MODE_KHR              0x1155
#define CL_SAMPLER_LOD_MIN_KHR                      0x1156
#define CL_SAMPLER_LOD_MAX_KHR                      0x1157




#define cl_khr_priority_hints 1

typedef cl_uint  cl_queue_priority_khr;


#define CL_QUEUE_PRIORITY_KHR 0x1096


#define CL_QUEUE_PRIORITY_HIGH_KHR (1<<0)
#define CL_QUEUE_PRIORITY_MED_KHR (1<<1)
#define CL_QUEUE_PRIORITY_LOW_KHR (1<<2)




#define cl_khr_throttle_hints 1

typedef cl_uint  cl_queue_throttle_khr;


#define CL_QUEUE_THROTTLE_KHR 0x1097


#define CL_QUEUE_THROTTLE_HIGH_KHR (1<<0)
#define CL_QUEUE_THROTTLE_MED_KHR (1<<1)
#define CL_QUEUE_THROTTLE_LOW_KHR (1<<2)




#define cl_khr_subgroup_named_barrier 1


#define CL_DEVICE_MAX_NAMED_BARRIER_COUNT_KHR       0x2035




#define cl_khr_extended_versioning 1

#define CL_VERSION_MAJOR_BITS_KHR (10)
#define CL_VERSION_MINOR_BITS_KHR (10)
#define CL_VERSION_PATCH_BITS_KHR (12)

#define CL_VERSION_MAJOR_MASK_KHR ((1 << CL_VERSION_MAJOR_BITS_KHR) - 1)
#define CL_VERSION_MINOR_MASK_KHR ((1 << CL_VERSION_MINOR_BITS_KHR) - 1)
#define CL_VERSION_PATCH_MASK_KHR ((1 << CL_VERSION_PATCH_BITS_KHR) - 1)

#define CL_VERSION_MAJOR_KHR(version) ((version) >> (CL_VERSION_MINOR_BITS_KHR + CL_VERSION_PATCH_BITS_KHR))
#define CL_VERSION_MINOR_KHR(version) (((version) >> CL_VERSION_PATCH_BITS_KHR) & CL_VERSION_MINOR_MASK_KHR)
#define CL_VERSION_PATCH_KHR(version) ((version) & CL_VERSION_PATCH_MASK_KHR)

#define CL_MAKE_VERSION_KHR(major, minor, patch) \
    ((((major) & CL_VERSION_MAJOR_MASK_KHR) << (CL_VERSION_MINOR_BITS_KHR + CL_VERSION_PATCH_BITS_KHR)) | \
    (((minor) &  CL_VERSION_MINOR_MASK_KHR) << CL_VERSION_PATCH_BITS_KHR) | \
    ((patch) & CL_VERSION_PATCH_MASK_KHR))

typedef cl_uint cl_version_khr;

#define CL_NAME_VERSION_MAX_NAME_SIZE_KHR 64

typedef struct _cl_name_version_khr
{
    cl_version_khr version;
    char name[CL_NAME_VERSION_MAX_NAME_SIZE_KHR];
} cl_name_version_khr;


#define CL_PLATFORM_NUMERIC_VERSION_KHR                  0x0906
#define CL_PLATFORM_EXTENSIONS_WITH_VERSION_KHR          0x0907


#define CL_DEVICE_NUMERIC_VERSION_KHR                    0x105E
#define CL_DEVICE_OPENCL_C_NUMERIC_VERSION_KHR           0x105F
#define CL_DEVICE_EXTENSIONS_WITH_VERSION_KHR            0x1060
#define CL_DEVICE_ILS_WITH_VERSION_KHR                   0x1061
#define CL_DEVICE_BUILT_IN_KERNELS_WITH_VERSION_KHR      0x1062



#define cl_khr_device_uuid 1

#define CL_UUID_SIZE_KHR 16
#define CL_LUID_SIZE_KHR 8

#define CL_DEVICE_UUID_KHR          0x106A
#define CL_DRIVER_UUID_KHR          0x106B
#define CL_DEVICE_LUID_VALID_KHR    0x106C
#define CL_DEVICE_LUID_KHR          0x106D
#define CL_DEVICE_NODE_MASK_KHR     0x106E


#define cl_khr_pci_bus_info 1

#define CL_DEVICE_PCI_BUS_INFO_KHR  0x410F 

typedef struct _cl_device_pci_bus_info_khr {
    cl_uint   pci_domain;
    cl_uint   pci_bus;
    cl_uint   pci_device;
    cl_uint   pci_function;
} cl_device_pci_bus_info_khr;


#define cl_arm_import_memory 1

typedef intptr_t cl_import_properties_arm;


#define CL_IMPORT_TYPE_ARM                        0x40B2


#define CL_IMPORT_TYPE_HOST_ARM                   0x40B3


#define CL_IMPORT_TYPE_DMA_BUF_ARM                0x40B4


#define CL_IMPORT_TYPE_PROTECTED_ARM              0x40B5


#define CL_IMPORT_TYPE_ANDROID_HARDWARE_BUFFER_ARM 0x41E2


#define CL_IMPORT_DMA_BUF_DATA_CONSISTENCY_WITH_HOST_ARM 0x41E3


#define CL_IMPORT_MEMORY_WHOLE_ALLOCATION_ARM SIZE_MAX


extern CL_API_ENTRY cl_mem CL_API_CALL
clImportMemoryARM( cl_context context,
                   cl_mem_flags flags,
                   const cl_import_properties_arm *properties,
                   void *memory,
                   size_t size,
                   cl_int *errcode_ret) CL_EXT_SUFFIX__VERSION_1_0;



#define cl_arm_shared_virtual_memory 1


#define CL_DEVICE_SVM_CAPABILITIES_ARM                  0x40B6


#define CL_MEM_USES_SVM_POINTER_ARM                     0x40B7


#define CL_KERNEL_EXEC_INFO_SVM_PTRS_ARM                0x40B8
#define CL_KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM_ARM   0x40B9


#define CL_COMMAND_SVM_FREE_ARM                         0x40BA
#define CL_COMMAND_SVM_MEMCPY_ARM                       0x40BB
#define CL_COMMAND_SVM_MEMFILL_ARM                      0x40BC
#define CL_COMMAND_SVM_MAP_ARM                          0x40BD
#define CL_COMMAND_SVM_UNMAP_ARM                        0x40BE


#define CL_DEVICE_SVM_COARSE_GRAIN_BUFFER_ARM           (1 << 0)
#define CL_DEVICE_SVM_FINE_GRAIN_BUFFER_ARM             (1 << 1)
#define CL_DEVICE_SVM_FINE_GRAIN_SYSTEM_ARM             (1 << 2)
#define CL_DEVICE_SVM_ATOMICS_ARM                       (1 << 3)


#define CL_MEM_SVM_FINE_GRAIN_BUFFER_ARM                (1 << 10)
#define CL_MEM_SVM_ATOMICS_ARM                          (1 << 11)

typedef cl_bitfield cl_svm_mem_flags_arm;
typedef cl_uint     cl_kernel_exec_info_arm;
typedef cl_bitfield cl_device_svm_capabilities_arm;

extern CL_API_ENTRY void * CL_API_CALL
clSVMAllocARM(cl_context       context,
              cl_svm_mem_flags_arm flags,
              size_t           size,
              cl_uint          alignment) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY void CL_API_CALL
clSVMFreeARM(cl_context        context,
             void *            svm_pointer) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSVMFreeARM(cl_command_queue  command_queue,
                    cl_uint           num_svm_pointers,
                    void *            svm_pointers[],
                    void (CL_CALLBACK * pfn_free_func)(cl_command_queue queue,
                                                       cl_uint          num_svm_pointers,
                                                       void *           svm_pointers[],
                                                       void *           user_data),
                    void *            user_data,
                    cl_uint           num_events_in_wait_list,
                    const cl_event *  event_wait_list,
                    cl_event *        event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSVMMemcpyARM(cl_command_queue  command_queue,
                      cl_bool           blocking_copy,
                      void *            dst_ptr,
                      const void *      src_ptr,
                      size_t            size,
                      cl_uint           num_events_in_wait_list,
                      const cl_event *  event_wait_list,
                      cl_event *        event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSVMMemFillARM(cl_command_queue  command_queue,
                       void *            svm_ptr,
                       const void *      pattern,
                       size_t            pattern_size,
                       size_t            size,
                       cl_uint           num_events_in_wait_list,
                       const cl_event *  event_wait_list,
                       cl_event *        event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSVMMapARM(cl_command_queue  command_queue,
                   cl_bool           blocking_map,
                   cl_map_flags      flags,
                   void *            svm_ptr,
                   size_t            size,
                   cl_uint           num_events_in_wait_list,
                   const cl_event *  event_wait_list,
                   cl_event *        event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueSVMUnmapARM(cl_command_queue  command_queue,
                     void *            svm_ptr,
                     cl_uint           num_events_in_wait_list,
                     const cl_event *  event_wait_list,
                     cl_event *        event) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clSetKernelArgSVMPointerARM(cl_kernel    kernel,
                            cl_uint      arg_index,
                            const void * arg_value) CL_EXT_SUFFIX__VERSION_1_2;

extern CL_API_ENTRY cl_int CL_API_CALL
clSetKernelExecInfoARM(cl_kernel            kernel,
                       cl_kernel_exec_info_arm  param_name,
                       size_t               param_value_size,
                       const void *         param_value) CL_EXT_SUFFIX__VERSION_1_2;



#ifdef CL_VERSION_1_2

#define cl_arm_get_core_id 1


#define CL_DEVICE_COMPUTE_UNITS_BITFIELD_ARM      0x40BF

#endif  



#define cl_arm_job_slot_selection 1


#define CL_DEVICE_JOB_SLOTS_ARM                   0x41E0


#define CL_QUEUE_JOB_SLOT_ARM                     0x41E1



#define cl_arm_scheduling_controls 1


#define CL_DEVICE_SCHEDULING_CONTROLS_CAPABILITIES_ARM          0x41E4

#define CL_DEVICE_SCHEDULING_KERNEL_BATCHING_ARM               (1 << 0)
#define CL_DEVICE_SCHEDULING_WORKGROUP_BATCH_SIZE_ARM          (1 << 1)
#define CL_DEVICE_SCHEDULING_WORKGROUP_BATCH_SIZE_MODIFIER_ARM (1 << 2)


#define CL_KERNEL_EXEC_INFO_WORKGROUP_BATCH_SIZE_ARM            0x41E5
#define CL_KERNEL_EXEC_INFO_WORKGROUP_BATCH_SIZE_MODIFIER_ARM   0x41E6


#define CL_QUEUE_KERNEL_BATCHING_ARM                            0x41E7

#ifdef __cplusplus
}
#endif

#endif 
