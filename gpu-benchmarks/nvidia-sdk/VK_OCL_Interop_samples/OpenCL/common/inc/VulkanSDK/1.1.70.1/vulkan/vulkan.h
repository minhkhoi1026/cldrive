#ifndef VULKAN_H_
#define VULKAN_H_ 1



#include "vk_platform.h"
#include "vulkan_core.h"

#ifdef VK_USE_PLATFORM_ANDROID_KHR
#include "vulkan_android.h"
#endif


#ifdef VK_USE_PLATFORM_IOS_MVK
#include "vulkan_ios.h"
#endif


#ifdef VK_USE_PLATFORM_MACOS_MVK
#include "vulkan_macos.h"
#endif


#ifdef VK_USE_PLATFORM_MIR_KHR
#include <mir_toolkit/client_types.h>
#include "vulkan_mir.h"
#endif


#ifdef VK_USE_PLATFORM_VI_NN
#include "vulkan_vi.h"
#endif


#ifdef VK_USE_PLATFORM_WAYLAND_KHR
#include <wayland-client.h>
#include "vulkan_wayland.h"
#endif


#ifdef VK_USE_PLATFORM_WIN32_KHR
#include <windows.h>
#include "vulkan_win32.h"
#endif


#ifdef VK_USE_PLATFORM_XCB_KHR
#include <xcb/xcb.h>
#include "vulkan_xcb.h"
#endif


#ifdef VK_USE_PLATFORM_XLIB_KHR
#include <X11/Xlib.h>
#include "vulkan_xlib.h"
#endif


#ifdef VK_USE_PLATFORM_XLIB_XRANDR_EXT
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>
#include "vulkan_xlib_xrandr.h"
#endif

#endif 
