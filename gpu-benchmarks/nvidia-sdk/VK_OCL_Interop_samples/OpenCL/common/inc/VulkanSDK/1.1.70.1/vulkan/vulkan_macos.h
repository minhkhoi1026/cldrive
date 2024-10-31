#ifndef VULKAN_MACOS_H_
#define VULKAN_MACOS_H_ 1

#ifdef __cplusplus
extern "C" {
#endif






#define VK_MVK_macos_surface 1
#define VK_MVK_MACOS_SURFACE_SPEC_VERSION 2
#define VK_MVK_MACOS_SURFACE_EXTENSION_NAME "VK_MVK_macos_surface"

typedef VkFlags VkMacOSSurfaceCreateFlagsMVK;

typedef struct VkMacOSSurfaceCreateInfoMVK {
    VkStructureType                 sType;
    const void*                     pNext;
    VkMacOSSurfaceCreateFlagsMVK    flags;
    const void*                     pView;
} VkMacOSSurfaceCreateInfoMVK;


typedef VkResult (VKAPI_PTR *PFN_vkCreateMacOSSurfaceMVK)(VkInstance instance, const VkMacOSSurfaceCreateInfoMVK* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkSurfaceKHR* pSurface);

#ifndef VK_NO_PROTOTYPES
VKAPI_ATTR VkResult VKAPI_CALL vkCreateMacOSSurfaceMVK(
    VkInstance                                  instance,
    const VkMacOSSurfaceCreateInfoMVK*          pCreateInfo,
    const VkAllocationCallbacks*                pAllocator,
    VkSurfaceKHR*                               pSurface);
#endif

#ifdef __cplusplus
}
#endif

#endif
