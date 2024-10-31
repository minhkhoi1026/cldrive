#ifndef VULKAN_ANDROID_H_
#define VULKAN_ANDROID_H_ 1

#ifdef __cplusplus
extern "C" {
#endif






#define VK_KHR_android_surface 1
struct ANativeWindow;

#define VK_KHR_ANDROID_SURFACE_SPEC_VERSION 6
#define VK_KHR_ANDROID_SURFACE_EXTENSION_NAME "VK_KHR_android_surface"

typedef VkFlags VkAndroidSurfaceCreateFlagsKHR;

typedef struct VkAndroidSurfaceCreateInfoKHR {
    VkStructureType                   sType;
    const void*                       pNext;
    VkAndroidSurfaceCreateFlagsKHR    flags;
    struct ANativeWindow*             window;
} VkAndroidSurfaceCreateInfoKHR;


typedef VkResult (VKAPI_PTR *PFN_vkCreateAndroidSurfaceKHR)(VkInstance instance, const VkAndroidSurfaceCreateInfoKHR* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkSurfaceKHR* pSurface);

#ifndef VK_NO_PROTOTYPES
VKAPI_ATTR VkResult VKAPI_CALL vkCreateAndroidSurfaceKHR(
    VkInstance                                  instance,
    const VkAndroidSurfaceCreateInfoKHR*        pCreateInfo,
    const VkAllocationCallbacks*                pAllocator,
    VkSurfaceKHR*                               pSurface);
#endif

#ifdef __cplusplus
}
#endif

#endif
