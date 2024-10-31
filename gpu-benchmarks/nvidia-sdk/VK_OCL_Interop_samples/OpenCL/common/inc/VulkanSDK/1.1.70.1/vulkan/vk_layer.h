





#pragma once

#include "vulkan.h"
#if defined(__GNUC__) && __GNUC__ >= 4
#define VK_LAYER_EXPORT __attribute__((visibility("default")))
#elif defined(__SUNPRO_C) && (__SUNPRO_C >= 0x590)
#define VK_LAYER_EXPORT __attribute__((visibility("default")))
#else
#define VK_LAYER_EXPORT
#endif


#include "vk_layer_dispatch_table.h"

#define MAX_NUM_UNKNOWN_EXTS 250

 
 
 
 
 
#define CURRENT_LOADER_LAYER_INTERFACE_VERSION 2
#define MIN_SUPPORTED_LOADER_LAYER_INTERFACE_VERSION 1

#define VK_CURRENT_CHAIN_VERSION 1


typedef enum VkNegotiateLayerStructType {
    LAYER_NEGOTIATE_UNINTIALIZED = 0,
    LAYER_NEGOTIATE_INTERFACE_STRUCT = 1,
} VkNegotiateLayerStructType;


typedef struct VkNegotiateLayerInterface {
    VkNegotiateLayerStructType sType;
    void *pNext;
    uint32_t loaderLayerInterfaceVersion;
    PFN_vkGetInstanceProcAddr pfnGetInstanceProcAddr;
    PFN_vkGetDeviceProcAddr pfnGetDeviceProcAddr;
    PFN_GetPhysicalDeviceProcAddr pfnGetPhysicalDeviceProcAddr;
} VkNegotiateLayerInterface;


typedef VkResult (VKAPI_PTR *PFN_vkNegotiateLoaderLayerInterfaceVersion)(VkNegotiateLayerInterface *pVersionStruct);


typedef VkResult(VKAPI_PTR *PFN_PhysDevExt)(VkPhysicalDevice phys_device);





typedef enum VkLayerFunction_ {
    VK_LAYER_LINK_INFO = 0,
    VK_LOADER_DATA_CALLBACK = 1
} VkLayerFunction;

typedef struct VkLayerInstanceLink_ {
    struct VkLayerInstanceLink_ *pNext;
    PFN_vkGetInstanceProcAddr pfnNextGetInstanceProcAddr;
    PFN_GetPhysicalDeviceProcAddr pfnNextGetPhysicalDeviceProcAddr;
} VkLayerInstanceLink;


typedef struct VkLayerDeviceInfo_ {
    void *device_info;
    PFN_vkGetInstanceProcAddr pfnNextGetInstanceProcAddr;
} VkLayerDeviceInfo;

typedef VkResult (VKAPI_PTR *PFN_vkSetInstanceLoaderData)(VkInstance instance,
        void *object);
typedef VkResult (VKAPI_PTR *PFN_vkSetDeviceLoaderData)(VkDevice device,
        void *object);

typedef struct {
    VkStructureType sType; 
    const void *pNext;
    VkLayerFunction function;
    union {
        VkLayerInstanceLink *pLayerInfo;
        PFN_vkSetInstanceLoaderData pfnSetInstanceLoaderData;
    } u;
} VkLayerInstanceCreateInfo;

typedef struct VkLayerDeviceLink_ {
    struct VkLayerDeviceLink_ *pNext;
    PFN_vkGetInstanceProcAddr pfnNextGetInstanceProcAddr;
    PFN_vkGetDeviceProcAddr pfnNextGetDeviceProcAddr;
} VkLayerDeviceLink;

typedef struct {
    VkStructureType sType; 
    const void *pNext;
    VkLayerFunction function;
    union {
        VkLayerDeviceLink *pLayerInfo;
        PFN_vkSetDeviceLoaderData pfnSetDeviceLoaderData;
    } u;
} VkLayerDeviceCreateInfo;

#ifdef __cplusplus
extern "C" {
#endif

VKAPI_ATTR VkResult VKAPI_CALL vkNegotiateLoaderLayerInterfaceVersion(VkNegotiateLayerInterface *pVersionStruct);

typedef enum VkChainType {
    VK_CHAIN_TYPE_UNKNOWN = 0,
    VK_CHAIN_TYPE_ENUMERATE_INSTANCE_EXTENSION_PROPERTIES = 1,
    VK_CHAIN_TYPE_ENUMERATE_INSTANCE_LAYER_PROPERTIES = 2,
    VK_CHAIN_TYPE_ENUMERATE_INSTANCE_VERSION = 3,
} VkChainType;

typedef struct VkChainHeader {
    VkChainType type;
    uint32_t version;
    uint32_t size;
} VkChainHeader;

typedef struct VkEnumerateInstanceExtensionPropertiesChain {
    VkChainHeader header;
    VkResult(VKAPI_PTR *pfnNextLayer)(const struct VkEnumerateInstanceExtensionPropertiesChain *, const char *, uint32_t *,
                                      VkExtensionProperties *);
    const struct VkEnumerateInstanceExtensionPropertiesChain *pNextLink;

#if defined(__cplusplus)
    inline VkResult CallDown(const char *pLayerName, uint32_t *pPropertyCount, VkExtensionProperties *pProperties) const {
        return pfnNextLayer(pNextLink, pLayerName, pPropertyCount, pProperties);
    }
#endif
} VkEnumerateInstanceExtensionPropertiesChain;

typedef struct VkEnumerateInstanceLayerPropertiesChain {
    VkChainHeader header;
    VkResult(VKAPI_PTR *pfnNextLayer)(const struct VkEnumerateInstanceLayerPropertiesChain *, uint32_t *, VkLayerProperties *);
    const struct VkEnumerateInstanceLayerPropertiesChain *pNextLink;

#if defined(__cplusplus)
    inline VkResult CallDown(uint32_t *pPropertyCount, VkLayerProperties *pProperties) const {
        return pfnNextLayer(pNextLink, pPropertyCount, pProperties);
    }
#endif
} VkEnumerateInstanceLayerPropertiesChain;

typedef struct VkEnumerateInstanceVersionChain {
    VkChainHeader header;
    VkResult(VKAPI_PTR *pfnNextLayer)(const struct VkEnumerateInstanceVersionChain *, uint32_t *);
    const struct VkEnumerateInstanceVersionChain *pNextLink;

#if defined(__cplusplus)
    inline VkResult CallDown(uint32_t *pApiVersion) const {
        return pfnNextLayer(pNextLink, pApiVersion);
    }
#endif
} VkEnumerateInstanceVersionChain;

#ifdef __cplusplus
}
#endif
