#ifndef VULKAN_MIR_H_
#define VULKAN_MIR_H_ 1

#ifdef __cplusplus
extern "C" {
#endif






#define VK_KHR_mir_surface 1
#define VK_KHR_MIR_SURFACE_SPEC_VERSION   4
#define VK_KHR_MIR_SURFACE_EXTENSION_NAME "VK_KHR_mir_surface"

typedef VkFlags VkMirSurfaceCreateFlagsKHR;

typedef struct VkMirSurfaceCreateInfoKHR {
    VkStructureType               sType;
    const void*                   pNext;
    VkMirSurfaceCreateFlagsKHR    flags;
    MirConnection*                connection;
    MirSurface*                   mirSurface;
} VkMirSurfaceCreateInfoKHR;


typedef VkResult (VKAPI_PTR *PFN_vkCreateMirSurfaceKHR)(VkInstance instance, const VkMirSurfaceCreateInfoKHR* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkSurfaceKHR* pSurface);
typedef VkBool32 (VKAPI_PTR *PFN_vkGetPhysicalDeviceMirPresentationSupportKHR)(VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, MirConnection* connection);

#ifndef VK_NO_PROTOTYPES
VKAPI_ATTR VkResult VKAPI_CALL vkCreateMirSurfaceKHR(
    VkInstance                                  instance,
    const VkMirSurfaceCreateInfoKHR*            pCreateInfo,
    const VkAllocationCallbacks*                pAllocator,
    VkSurfaceKHR*                               pSurface);

VKAPI_ATTR VkBool32 VKAPI_CALL vkGetPhysicalDeviceMirPresentationSupportKHR(
    VkPhysicalDevice                            physicalDevice,
    uint32_t                                    queueFamilyIndex,
    MirConnection*                              connection);
#endif

#ifdef __cplusplus
}
#endif

#endif
