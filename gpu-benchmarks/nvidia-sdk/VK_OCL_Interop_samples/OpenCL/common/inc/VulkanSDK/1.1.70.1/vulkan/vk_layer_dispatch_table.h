




#pragma once

typedef PFN_vkVoidFunction (VKAPI_PTR *PFN_GetPhysicalDeviceProcAddr)(VkInstance instance, const char* pName);


typedef struct VkLayerInstanceDispatchTable_ {
    
    PFN_GetPhysicalDeviceProcAddr GetPhysicalDeviceProcAddr;

    
    PFN_vkCreateInstance CreateInstance;
    PFN_vkDestroyInstance DestroyInstance;
    PFN_vkEnumeratePhysicalDevices EnumeratePhysicalDevices;
    PFN_vkGetPhysicalDeviceFeatures GetPhysicalDeviceFeatures;
    PFN_vkGetPhysicalDeviceFormatProperties GetPhysicalDeviceFormatProperties;
    PFN_vkGetPhysicalDeviceImageFormatProperties GetPhysicalDeviceImageFormatProperties;
    PFN_vkGetPhysicalDeviceProperties GetPhysicalDeviceProperties;
    PFN_vkGetPhysicalDeviceQueueFamilyProperties GetPhysicalDeviceQueueFamilyProperties;
    PFN_vkGetPhysicalDeviceMemoryProperties GetPhysicalDeviceMemoryProperties;
    PFN_vkGetInstanceProcAddr GetInstanceProcAddr;
    PFN_vkCreateDevice CreateDevice;
    PFN_vkEnumerateInstanceExtensionProperties EnumerateInstanceExtensionProperties;
    PFN_vkEnumerateDeviceExtensionProperties EnumerateDeviceExtensionProperties;
    PFN_vkEnumerateInstanceLayerProperties EnumerateInstanceLayerProperties;
    PFN_vkEnumerateDeviceLayerProperties EnumerateDeviceLayerProperties;
    PFN_vkGetPhysicalDeviceSparseImageFormatProperties GetPhysicalDeviceSparseImageFormatProperties;

    
    PFN_vkEnumerateInstanceVersion EnumerateInstanceVersion;
    PFN_vkEnumeratePhysicalDeviceGroups EnumeratePhysicalDeviceGroups;
    PFN_vkGetPhysicalDeviceFeatures2 GetPhysicalDeviceFeatures2;
    PFN_vkGetPhysicalDeviceProperties2 GetPhysicalDeviceProperties2;
    PFN_vkGetPhysicalDeviceFormatProperties2 GetPhysicalDeviceFormatProperties2;
    PFN_vkGetPhysicalDeviceImageFormatProperties2 GetPhysicalDeviceImageFormatProperties2;
    PFN_vkGetPhysicalDeviceQueueFamilyProperties2 GetPhysicalDeviceQueueFamilyProperties2;
    PFN_vkGetPhysicalDeviceMemoryProperties2 GetPhysicalDeviceMemoryProperties2;
    PFN_vkGetPhysicalDeviceSparseImageFormatProperties2 GetPhysicalDeviceSparseImageFormatProperties2;
    PFN_vkGetPhysicalDeviceExternalBufferProperties GetPhysicalDeviceExternalBufferProperties;
    PFN_vkGetPhysicalDeviceExternalFenceProperties GetPhysicalDeviceExternalFenceProperties;
    PFN_vkGetPhysicalDeviceExternalSemaphoreProperties GetPhysicalDeviceExternalSemaphoreProperties;

    
    PFN_vkDestroySurfaceKHR DestroySurfaceKHR;
    PFN_vkGetPhysicalDeviceSurfaceSupportKHR GetPhysicalDeviceSurfaceSupportKHR;
    PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR GetPhysicalDeviceSurfaceCapabilitiesKHR;
    PFN_vkGetPhysicalDeviceSurfaceFormatsKHR GetPhysicalDeviceSurfaceFormatsKHR;
    PFN_vkGetPhysicalDeviceSurfacePresentModesKHR GetPhysicalDeviceSurfacePresentModesKHR;

    
    PFN_vkGetPhysicalDevicePresentRectanglesKHR GetPhysicalDevicePresentRectanglesKHR;

    
    PFN_vkGetPhysicalDeviceDisplayPropertiesKHR GetPhysicalDeviceDisplayPropertiesKHR;
    PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR GetPhysicalDeviceDisplayPlanePropertiesKHR;
    PFN_vkGetDisplayPlaneSupportedDisplaysKHR GetDisplayPlaneSupportedDisplaysKHR;
    PFN_vkGetDisplayModePropertiesKHR GetDisplayModePropertiesKHR;
    PFN_vkCreateDisplayModeKHR CreateDisplayModeKHR;
    PFN_vkGetDisplayPlaneCapabilitiesKHR GetDisplayPlaneCapabilitiesKHR;
    PFN_vkCreateDisplayPlaneSurfaceKHR CreateDisplayPlaneSurfaceKHR;

    
#ifdef VK_USE_PLATFORM_XLIB_KHR
    PFN_vkCreateXlibSurfaceKHR CreateXlibSurfaceKHR;
#endif 
#ifdef VK_USE_PLATFORM_XLIB_KHR
    PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR GetPhysicalDeviceXlibPresentationSupportKHR;
#endif 

    
#ifdef VK_USE_PLATFORM_XCB_KHR
    PFN_vkCreateXcbSurfaceKHR CreateXcbSurfaceKHR;
#endif 
#ifdef VK_USE_PLATFORM_XCB_KHR
    PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR GetPhysicalDeviceXcbPresentationSupportKHR;
#endif 

    
#ifdef VK_USE_PLATFORM_WAYLAND_KHR
    PFN_vkCreateWaylandSurfaceKHR CreateWaylandSurfaceKHR;
#endif 
#ifdef VK_USE_PLATFORM_WAYLAND_KHR
    PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR GetPhysicalDeviceWaylandPresentationSupportKHR;
#endif 

    
#ifdef VK_USE_PLATFORM_MIR_KHR
    PFN_vkCreateMirSurfaceKHR CreateMirSurfaceKHR;
#endif 
#ifdef VK_USE_PLATFORM_MIR_KHR
    PFN_vkGetPhysicalDeviceMirPresentationSupportKHR GetPhysicalDeviceMirPresentationSupportKHR;
#endif 

    
#ifdef VK_USE_PLATFORM_ANDROID_KHR
    PFN_vkCreateAndroidSurfaceKHR CreateAndroidSurfaceKHR;
#endif 

    
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkCreateWin32SurfaceKHR CreateWin32SurfaceKHR;
#endif 
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR GetPhysicalDeviceWin32PresentationSupportKHR;
#endif 

    
    PFN_vkGetPhysicalDeviceFeatures2KHR GetPhysicalDeviceFeatures2KHR;
    PFN_vkGetPhysicalDeviceProperties2KHR GetPhysicalDeviceProperties2KHR;
    PFN_vkGetPhysicalDeviceFormatProperties2KHR GetPhysicalDeviceFormatProperties2KHR;
    PFN_vkGetPhysicalDeviceImageFormatProperties2KHR GetPhysicalDeviceImageFormatProperties2KHR;
    PFN_vkGetPhysicalDeviceQueueFamilyProperties2KHR GetPhysicalDeviceQueueFamilyProperties2KHR;
    PFN_vkGetPhysicalDeviceMemoryProperties2KHR GetPhysicalDeviceMemoryProperties2KHR;
    PFN_vkGetPhysicalDeviceSparseImageFormatProperties2KHR GetPhysicalDeviceSparseImageFormatProperties2KHR;

    
    PFN_vkEnumeratePhysicalDeviceGroupsKHR EnumeratePhysicalDeviceGroupsKHR;

    
    PFN_vkGetPhysicalDeviceExternalBufferPropertiesKHR GetPhysicalDeviceExternalBufferPropertiesKHR;

    
    PFN_vkGetPhysicalDeviceExternalSemaphorePropertiesKHR GetPhysicalDeviceExternalSemaphorePropertiesKHR;

    
    PFN_vkGetPhysicalDeviceExternalFencePropertiesKHR GetPhysicalDeviceExternalFencePropertiesKHR;

    
    PFN_vkGetPhysicalDeviceSurfaceCapabilities2KHR GetPhysicalDeviceSurfaceCapabilities2KHR;
    PFN_vkGetPhysicalDeviceSurfaceFormats2KHR GetPhysicalDeviceSurfaceFormats2KHR;

    
    PFN_vkCreateDebugReportCallbackEXT CreateDebugReportCallbackEXT;
    PFN_vkDestroyDebugReportCallbackEXT DestroyDebugReportCallbackEXT;
    PFN_vkDebugReportMessageEXT DebugReportMessageEXT;

    
    PFN_vkGetPhysicalDeviceExternalImageFormatPropertiesNV GetPhysicalDeviceExternalImageFormatPropertiesNV;

    
#ifdef VK_USE_PLATFORM_VI_NN
    PFN_vkCreateViSurfaceNN CreateViSurfaceNN;
#endif 

    
    PFN_vkGetPhysicalDeviceGeneratedCommandsPropertiesNVX GetPhysicalDeviceGeneratedCommandsPropertiesNVX;

    
    PFN_vkReleaseDisplayEXT ReleaseDisplayEXT;

    
#ifdef VK_USE_PLATFORM_XLIB_XRANDR_EXT
    PFN_vkAcquireXlibDisplayEXT AcquireXlibDisplayEXT;
#endif 
#ifdef VK_USE_PLATFORM_XLIB_XRANDR_EXT
    PFN_vkGetRandROutputDisplayEXT GetRandROutputDisplayEXT;
#endif 

    
    PFN_vkGetPhysicalDeviceSurfaceCapabilities2EXT GetPhysicalDeviceSurfaceCapabilities2EXT;

    
#ifdef VK_USE_PLATFORM_IOS_MVK
    PFN_vkCreateIOSSurfaceMVK CreateIOSSurfaceMVK;
#endif 

    
#ifdef VK_USE_PLATFORM_MACOS_MVK
    PFN_vkCreateMacOSSurfaceMVK CreateMacOSSurfaceMVK;
#endif 

    
    PFN_vkCreateDebugUtilsMessengerEXT CreateDebugUtilsMessengerEXT;
    PFN_vkDestroyDebugUtilsMessengerEXT DestroyDebugUtilsMessengerEXT;
    PFN_vkSubmitDebugUtilsMessageEXT SubmitDebugUtilsMessageEXT;

    
    PFN_vkGetPhysicalDeviceMultisamplePropertiesEXT GetPhysicalDeviceMultisamplePropertiesEXT;
} VkLayerInstanceDispatchTable;


typedef struct VkLayerDispatchTable_ {

    
    PFN_vkGetDeviceProcAddr GetDeviceProcAddr;
    PFN_vkDestroyDevice DestroyDevice;
    PFN_vkGetDeviceQueue GetDeviceQueue;
    PFN_vkQueueSubmit QueueSubmit;
    PFN_vkQueueWaitIdle QueueWaitIdle;
    PFN_vkDeviceWaitIdle DeviceWaitIdle;
    PFN_vkAllocateMemory AllocateMemory;
    PFN_vkFreeMemory FreeMemory;
    PFN_vkMapMemory MapMemory;
    PFN_vkUnmapMemory UnmapMemory;
    PFN_vkFlushMappedMemoryRanges FlushMappedMemoryRanges;
    PFN_vkInvalidateMappedMemoryRanges InvalidateMappedMemoryRanges;
    PFN_vkGetDeviceMemoryCommitment GetDeviceMemoryCommitment;
    PFN_vkBindBufferMemory BindBufferMemory;
    PFN_vkBindImageMemory BindImageMemory;
    PFN_vkGetBufferMemoryRequirements GetBufferMemoryRequirements;
    PFN_vkGetImageMemoryRequirements GetImageMemoryRequirements;
    PFN_vkGetImageSparseMemoryRequirements GetImageSparseMemoryRequirements;
    PFN_vkQueueBindSparse QueueBindSparse;
    PFN_vkCreateFence CreateFence;
    PFN_vkDestroyFence DestroyFence;
    PFN_vkResetFences ResetFences;
    PFN_vkGetFenceStatus GetFenceStatus;
    PFN_vkWaitForFences WaitForFences;
    PFN_vkCreateSemaphore CreateSemaphore;
    PFN_vkDestroySemaphore DestroySemaphore;
    PFN_vkCreateEvent CreateEvent;
    PFN_vkDestroyEvent DestroyEvent;
    PFN_vkGetEventStatus GetEventStatus;
    PFN_vkSetEvent SetEvent;
    PFN_vkResetEvent ResetEvent;
    PFN_vkCreateQueryPool CreateQueryPool;
    PFN_vkDestroyQueryPool DestroyQueryPool;
    PFN_vkGetQueryPoolResults GetQueryPoolResults;
    PFN_vkCreateBuffer CreateBuffer;
    PFN_vkDestroyBuffer DestroyBuffer;
    PFN_vkCreateBufferView CreateBufferView;
    PFN_vkDestroyBufferView DestroyBufferView;
    PFN_vkCreateImage CreateImage;
    PFN_vkDestroyImage DestroyImage;
    PFN_vkGetImageSubresourceLayout GetImageSubresourceLayout;
    PFN_vkCreateImageView CreateImageView;
    PFN_vkDestroyImageView DestroyImageView;
    PFN_vkCreateShaderModule CreateShaderModule;
    PFN_vkDestroyShaderModule DestroyShaderModule;
    PFN_vkCreatePipelineCache CreatePipelineCache;
    PFN_vkDestroyPipelineCache DestroyPipelineCache;
    PFN_vkGetPipelineCacheData GetPipelineCacheData;
    PFN_vkMergePipelineCaches MergePipelineCaches;
    PFN_vkCreateGraphicsPipelines CreateGraphicsPipelines;
    PFN_vkCreateComputePipelines CreateComputePipelines;
    PFN_vkDestroyPipeline DestroyPipeline;
    PFN_vkCreatePipelineLayout CreatePipelineLayout;
    PFN_vkDestroyPipelineLayout DestroyPipelineLayout;
    PFN_vkCreateSampler CreateSampler;
    PFN_vkDestroySampler DestroySampler;
    PFN_vkCreateDescriptorSetLayout CreateDescriptorSetLayout;
    PFN_vkDestroyDescriptorSetLayout DestroyDescriptorSetLayout;
    PFN_vkCreateDescriptorPool CreateDescriptorPool;
    PFN_vkDestroyDescriptorPool DestroyDescriptorPool;
    PFN_vkResetDescriptorPool ResetDescriptorPool;
    PFN_vkAllocateDescriptorSets AllocateDescriptorSets;
    PFN_vkFreeDescriptorSets FreeDescriptorSets;
    PFN_vkUpdateDescriptorSets UpdateDescriptorSets;
    PFN_vkCreateFramebuffer CreateFramebuffer;
    PFN_vkDestroyFramebuffer DestroyFramebuffer;
    PFN_vkCreateRenderPass CreateRenderPass;
    PFN_vkDestroyRenderPass DestroyRenderPass;
    PFN_vkGetRenderAreaGranularity GetRenderAreaGranularity;
    PFN_vkCreateCommandPool CreateCommandPool;
    PFN_vkDestroyCommandPool DestroyCommandPool;
    PFN_vkResetCommandPool ResetCommandPool;
    PFN_vkAllocateCommandBuffers AllocateCommandBuffers;
    PFN_vkFreeCommandBuffers FreeCommandBuffers;
    PFN_vkBeginCommandBuffer BeginCommandBuffer;
    PFN_vkEndCommandBuffer EndCommandBuffer;
    PFN_vkResetCommandBuffer ResetCommandBuffer;
    PFN_vkCmdBindPipeline CmdBindPipeline;
    PFN_vkCmdSetViewport CmdSetViewport;
    PFN_vkCmdSetScissor CmdSetScissor;
    PFN_vkCmdSetLineWidth CmdSetLineWidth;
    PFN_vkCmdSetDepthBias CmdSetDepthBias;
    PFN_vkCmdSetBlendConstants CmdSetBlendConstants;
    PFN_vkCmdSetDepthBounds CmdSetDepthBounds;
    PFN_vkCmdSetStencilCompareMask CmdSetStencilCompareMask;
    PFN_vkCmdSetStencilWriteMask CmdSetStencilWriteMask;
    PFN_vkCmdSetStencilReference CmdSetStencilReference;
    PFN_vkCmdBindDescriptorSets CmdBindDescriptorSets;
    PFN_vkCmdBindIndexBuffer CmdBindIndexBuffer;
    PFN_vkCmdBindVertexBuffers CmdBindVertexBuffers;
    PFN_vkCmdDraw CmdDraw;
    PFN_vkCmdDrawIndexed CmdDrawIndexed;
    PFN_vkCmdDrawIndirect CmdDrawIndirect;
    PFN_vkCmdDrawIndexedIndirect CmdDrawIndexedIndirect;
    PFN_vkCmdDispatch CmdDispatch;
    PFN_vkCmdDispatchIndirect CmdDispatchIndirect;
    PFN_vkCmdCopyBuffer CmdCopyBuffer;
    PFN_vkCmdCopyImage CmdCopyImage;
    PFN_vkCmdBlitImage CmdBlitImage;
    PFN_vkCmdCopyBufferToImage CmdCopyBufferToImage;
    PFN_vkCmdCopyImageToBuffer CmdCopyImageToBuffer;
    PFN_vkCmdUpdateBuffer CmdUpdateBuffer;
    PFN_vkCmdFillBuffer CmdFillBuffer;
    PFN_vkCmdClearColorImage CmdClearColorImage;
    PFN_vkCmdClearDepthStencilImage CmdClearDepthStencilImage;
    PFN_vkCmdClearAttachments CmdClearAttachments;
    PFN_vkCmdResolveImage CmdResolveImage;
    PFN_vkCmdSetEvent CmdSetEvent;
    PFN_vkCmdResetEvent CmdResetEvent;
    PFN_vkCmdWaitEvents CmdWaitEvents;
    PFN_vkCmdPipelineBarrier CmdPipelineBarrier;
    PFN_vkCmdBeginQuery CmdBeginQuery;
    PFN_vkCmdEndQuery CmdEndQuery;
    PFN_vkCmdResetQueryPool CmdResetQueryPool;
    PFN_vkCmdWriteTimestamp CmdWriteTimestamp;
    PFN_vkCmdCopyQueryPoolResults CmdCopyQueryPoolResults;
    PFN_vkCmdPushConstants CmdPushConstants;
    PFN_vkCmdBeginRenderPass CmdBeginRenderPass;
    PFN_vkCmdNextSubpass CmdNextSubpass;
    PFN_vkCmdEndRenderPass CmdEndRenderPass;
    PFN_vkCmdExecuteCommands CmdExecuteCommands;

    
    PFN_vkBindBufferMemory2 BindBufferMemory2;
    PFN_vkBindImageMemory2 BindImageMemory2;
    PFN_vkGetDeviceGroupPeerMemoryFeatures GetDeviceGroupPeerMemoryFeatures;
    PFN_vkCmdSetDeviceMask CmdSetDeviceMask;
    PFN_vkCmdDispatchBase CmdDispatchBase;
    PFN_vkGetImageMemoryRequirements2 GetImageMemoryRequirements2;
    PFN_vkGetBufferMemoryRequirements2 GetBufferMemoryRequirements2;
    PFN_vkGetImageSparseMemoryRequirements2 GetImageSparseMemoryRequirements2;
    PFN_vkTrimCommandPool TrimCommandPool;
    PFN_vkGetDeviceQueue2 GetDeviceQueue2;
    PFN_vkCreateSamplerYcbcrConversion CreateSamplerYcbcrConversion;
    PFN_vkDestroySamplerYcbcrConversion DestroySamplerYcbcrConversion;
    PFN_vkCreateDescriptorUpdateTemplate CreateDescriptorUpdateTemplate;
    PFN_vkDestroyDescriptorUpdateTemplate DestroyDescriptorUpdateTemplate;
    PFN_vkUpdateDescriptorSetWithTemplate UpdateDescriptorSetWithTemplate;
    PFN_vkGetDescriptorSetLayoutSupport GetDescriptorSetLayoutSupport;

    
    PFN_vkCreateSwapchainKHR CreateSwapchainKHR;
    PFN_vkDestroySwapchainKHR DestroySwapchainKHR;
    PFN_vkGetSwapchainImagesKHR GetSwapchainImagesKHR;
    PFN_vkAcquireNextImageKHR AcquireNextImageKHR;
    PFN_vkQueuePresentKHR QueuePresentKHR;
    PFN_vkGetDeviceGroupPresentCapabilitiesKHR GetDeviceGroupPresentCapabilitiesKHR;
    PFN_vkGetDeviceGroupSurfacePresentModesKHR GetDeviceGroupSurfacePresentModesKHR;
    PFN_vkAcquireNextImage2KHR AcquireNextImage2KHR;

    
    PFN_vkCreateSharedSwapchainsKHR CreateSharedSwapchainsKHR;

    
    PFN_vkGetDeviceGroupPeerMemoryFeaturesKHR GetDeviceGroupPeerMemoryFeaturesKHR;
    PFN_vkCmdSetDeviceMaskKHR CmdSetDeviceMaskKHR;
    PFN_vkCmdDispatchBaseKHR CmdDispatchBaseKHR;

    
    PFN_vkTrimCommandPoolKHR TrimCommandPoolKHR;

    
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetMemoryWin32HandleKHR GetMemoryWin32HandleKHR;
#endif 
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetMemoryWin32HandlePropertiesKHR GetMemoryWin32HandlePropertiesKHR;
#endif 

    
    PFN_vkGetMemoryFdKHR GetMemoryFdKHR;
    PFN_vkGetMemoryFdPropertiesKHR GetMemoryFdPropertiesKHR;

    
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkImportSemaphoreWin32HandleKHR ImportSemaphoreWin32HandleKHR;
#endif 
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetSemaphoreWin32HandleKHR GetSemaphoreWin32HandleKHR;
#endif 

    
    PFN_vkImportSemaphoreFdKHR ImportSemaphoreFdKHR;
    PFN_vkGetSemaphoreFdKHR GetSemaphoreFdKHR;

    
    PFN_vkCmdPushDescriptorSetKHR CmdPushDescriptorSetKHR;
    PFN_vkCmdPushDescriptorSetWithTemplateKHR CmdPushDescriptorSetWithTemplateKHR;

    
    PFN_vkCreateDescriptorUpdateTemplateKHR CreateDescriptorUpdateTemplateKHR;
    PFN_vkDestroyDescriptorUpdateTemplateKHR DestroyDescriptorUpdateTemplateKHR;
    PFN_vkUpdateDescriptorSetWithTemplateKHR UpdateDescriptorSetWithTemplateKHR;

    
    PFN_vkGetSwapchainStatusKHR GetSwapchainStatusKHR;

    
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkImportFenceWin32HandleKHR ImportFenceWin32HandleKHR;
#endif 
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetFenceWin32HandleKHR GetFenceWin32HandleKHR;
#endif 

    
    PFN_vkImportFenceFdKHR ImportFenceFdKHR;
    PFN_vkGetFenceFdKHR GetFenceFdKHR;

    
    PFN_vkGetImageMemoryRequirements2KHR GetImageMemoryRequirements2KHR;
    PFN_vkGetBufferMemoryRequirements2KHR GetBufferMemoryRequirements2KHR;
    PFN_vkGetImageSparseMemoryRequirements2KHR GetImageSparseMemoryRequirements2KHR;

    
    PFN_vkCreateSamplerYcbcrConversionKHR CreateSamplerYcbcrConversionKHR;
    PFN_vkDestroySamplerYcbcrConversionKHR DestroySamplerYcbcrConversionKHR;

    
    PFN_vkBindBufferMemory2KHR BindBufferMemory2KHR;
    PFN_vkBindImageMemory2KHR BindImageMemory2KHR;

    
    PFN_vkGetDescriptorSetLayoutSupportKHR GetDescriptorSetLayoutSupportKHR;

    
    PFN_vkDebugMarkerSetObjectTagEXT DebugMarkerSetObjectTagEXT;
    PFN_vkDebugMarkerSetObjectNameEXT DebugMarkerSetObjectNameEXT;
    PFN_vkCmdDebugMarkerBeginEXT CmdDebugMarkerBeginEXT;
    PFN_vkCmdDebugMarkerEndEXT CmdDebugMarkerEndEXT;
    PFN_vkCmdDebugMarkerInsertEXT CmdDebugMarkerInsertEXT;

    
    PFN_vkCmdDrawIndirectCountAMD CmdDrawIndirectCountAMD;
    PFN_vkCmdDrawIndexedIndirectCountAMD CmdDrawIndexedIndirectCountAMD;

    
    PFN_vkGetShaderInfoAMD GetShaderInfoAMD;

    
#ifdef VK_USE_PLATFORM_WIN32_KHR
    PFN_vkGetMemoryWin32HandleNV GetMemoryWin32HandleNV;
#endif 

    
    PFN_vkCmdProcessCommandsNVX CmdProcessCommandsNVX;
    PFN_vkCmdReserveSpaceForCommandsNVX CmdReserveSpaceForCommandsNVX;
    PFN_vkCreateIndirectCommandsLayoutNVX CreateIndirectCommandsLayoutNVX;
    PFN_vkDestroyIndirectCommandsLayoutNVX DestroyIndirectCommandsLayoutNVX;
    PFN_vkCreateObjectTableNVX CreateObjectTableNVX;
    PFN_vkDestroyObjectTableNVX DestroyObjectTableNVX;
    PFN_vkRegisterObjectsNVX RegisterObjectsNVX;
    PFN_vkUnregisterObjectsNVX UnregisterObjectsNVX;

    
    PFN_vkCmdSetViewportWScalingNV CmdSetViewportWScalingNV;

    
    PFN_vkDisplayPowerControlEXT DisplayPowerControlEXT;
    PFN_vkRegisterDeviceEventEXT RegisterDeviceEventEXT;
    PFN_vkRegisterDisplayEventEXT RegisterDisplayEventEXT;
    PFN_vkGetSwapchainCounterEXT GetSwapchainCounterEXT;

    
    PFN_vkGetRefreshCycleDurationGOOGLE GetRefreshCycleDurationGOOGLE;
    PFN_vkGetPastPresentationTimingGOOGLE GetPastPresentationTimingGOOGLE;

    
    PFN_vkCmdSetDiscardRectangleEXT CmdSetDiscardRectangleEXT;

    
    PFN_vkSetHdrMetadataEXT SetHdrMetadataEXT;

    
    PFN_vkSetDebugUtilsObjectNameEXT SetDebugUtilsObjectNameEXT;
    PFN_vkSetDebugUtilsObjectTagEXT SetDebugUtilsObjectTagEXT;
    PFN_vkQueueBeginDebugUtilsLabelEXT QueueBeginDebugUtilsLabelEXT;
    PFN_vkQueueEndDebugUtilsLabelEXT QueueEndDebugUtilsLabelEXT;
    PFN_vkQueueInsertDebugUtilsLabelEXT QueueInsertDebugUtilsLabelEXT;
    PFN_vkCmdBeginDebugUtilsLabelEXT CmdBeginDebugUtilsLabelEXT;
    PFN_vkCmdEndDebugUtilsLabelEXT CmdEndDebugUtilsLabelEXT;
    PFN_vkCmdInsertDebugUtilsLabelEXT CmdInsertDebugUtilsLabelEXT;

    
    PFN_vkCmdSetSampleLocationsEXT CmdSetSampleLocationsEXT;

    
    PFN_vkCreateValidationCacheEXT CreateValidationCacheEXT;
    PFN_vkDestroyValidationCacheEXT DestroyValidationCacheEXT;
    PFN_vkMergeValidationCachesEXT MergeValidationCachesEXT;
    PFN_vkGetValidationCacheDataEXT GetValidationCacheDataEXT;

    
    PFN_vkGetMemoryHostPointerPropertiesEXT GetMemoryHostPointerPropertiesEXT;

    
    PFN_vkCmdWriteBufferMarkerAMD CmdWriteBufferMarkerAMD;
} VkLayerDispatchTable;


