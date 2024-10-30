/* Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of NVIDIA CORPORATION nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define GLFW_INCLUDE_VULKAN
#define NOMINMAX
#ifdef _WIN32
#include <aclapi.h>
#include <dxgi1_2.h>
#include <windows.h>
#include <VersionHelpers.h>
#define _USE_MATH_DEFINES
#endif

#include <GLFW/glfw3.h>
#include <vulkan/vulkan.h>
#ifdef _WIN32
#include <vulkan/vulkan_win32.h>
#endif

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <set>
#include <stdexcept>
#include <thread>
#include <vector>

 //OpenCL
#include <oclUtils.h>
#include <CL/cl.h>
#include <CL/cl_ext.h>
#include <assert.h>

#include "helper_image.h"
#include "limits.h"
#include "linmath.h"

#define WIDTH 800
#define HEIGHT 600
#define BUFFERSIZE 3000

#ifndef UINT_MAX
#define UINT_MAX 4294967295
#endif
const int MAX_FRAMES = 4;

const std::vector<const char*> validationLayers = {
	"VK_LAYER_KHRONOS_validation" };

#ifdef NDEBUG
const bool enableValidationLayers = false;
#else
const bool enableValidationLayers = false;
#endif

unsigned int maxFrames = 1000;
const char* program_source_const;
size_t program_source_length;
std::string execution_path;
cl_kernel kernel_1;
cl_kernel kernel_2;
cl_kernel kernel_3;
cl_program program;
cl_platform_id opencl_platform = NULL;
cl_uchar uuid[CL_UUID_SIZE_KHR];
cl_device_id deviceId;

VkImageCreateInfo imageInfo1;


typedef cl_semaphore_khr(*pfnclCreateSemaphoreWithPropertiesKHR) (cl_context context, cl_semaphore_properties_khr* sema_props, cl_int* errcode_ret);

typedef cl_int(*pfnclEnqueueWaitSemaphoresKHR) (cl_command_queue command_queue, cl_uint num_semaphores, const cl_semaphore_khr* sema_list, const cl_semaphore_payload* sema_payload_list, cl_uint num_events_in_wait_list, const cl_event* event_wait_list, cl_event* event);

typedef cl_int(*pfnclEnqueueSignalSemaphoresKHR) (cl_command_queue command_queue, cl_uint num_semaphores, const cl_semaphore_khr* sema_list, const cl_semaphore_payload* sema_payload_list, cl_uint num_events_in_wait_list, const cl_event* event_wait_list, cl_event* event);

typedef cl_int(*pfnclEnqueueAcquireExternalMemObjectsKHR) (cl_command_queue command_queue, cl_uint num_mem_objects, const cl_mem* mem_objects, cl_uint num_events_in_wait_list, const cl_event* event_wait_list, cl_event* event);

typedef cl_int(*pfnclEnqueueReleaseExternalMemObjectsKHR) (cl_command_queue command_queue, cl_uint num_mem_objects, const cl_mem* mem_objects, cl_uint num_events_in_wait_list, const cl_event* event_wait_list, cl_event* event);

typedef cl_int(*pfnclReleaseSemaphoreObjectKHR) (cl_semaphore_khr sema_object);

pfnclCreateSemaphoreWithPropertiesKHR clCreateSemaphoreWithPropertiesKHRptr;
pfnclEnqueueWaitSemaphoresKHR clEnqueueWaitSemaphoresKHRptr;
pfnclEnqueueSignalSemaphoresKHR clEnqueueSignalSemaphoresKHRptr;
pfnclEnqueueAcquireExternalMemObjectsKHR clEnqueueAcquireExternalMemObjectsKHRptr;
pfnclEnqueueReleaseExternalMemObjectsKHR clEnqueueReleaseExternalMemObjectsKHRptr;
pfnclReleaseSemaphoreObjectKHR clReleaseSemaphoreObjectKHRptr;

#define checkResult(result, msg)                                                                       \
    ((result != CL_SUCCESS) ?                                                                          \
    (printf("%s:%d: error: function %s failed with errcode %d\n", __FILE__, __LINE__, msg, result))     :   \
    (0)) \

bool isExtensionAvailable(cl_device_id device, const char* extensionName) {

	cl_int errNum;
	size_t extensionSize;

	errNum = clGetDeviceInfo(device, CL_DEVICE_EXTENSIONS, 0, NULL, &extensionSize);
	if (errNum != CL_SUCCESS) {
		throw std::runtime_error(" clGetDeviceInfo failed in getting extensionSize\n");
	}
	if (extensionSize > 0) {
		char* extensions = (char*)malloc(extensionSize);
		if (extensions == NULL) {
			throw std::runtime_error(" Unable to allocate memory for extension str");
		}
		errNum = clGetDeviceInfo(device, CL_DEVICE_EXTENSIONS, extensionSize, extensions, &extensionSize);
		if (errNum != CL_SUCCESS) {
			free(extensions);
			throw std::runtime_error(" clGetDeviceInfo failed in querying extension str\n");
		}
		if (strstr(extensions, extensionName) != NULL) {
			return true;
		}
	}
	return false;
}

cl_int check_external_memory_handle_type(cl_device_id deviceID, cl_external_mem_handle_type_khr requiredHandleType)
{
	unsigned int i;
	cl_external_mem_handle_type_khr* handle_type;
	size_t handle_type_size = 0;

	cl_int errNum = CL_SUCCESS;

	errNum = clGetDeviceInfo(deviceID, CL_DEVICE_EXTERNAL_MEMORY_IMPORT_HANDLE_TYPES_KHR, 0, NULL, &handle_type_size);
	handle_type = (cl_external_mem_handle_type_khr*)malloc(handle_type_size);

	errNum = clGetDeviceInfo(deviceID, CL_DEVICE_EXTERNAL_MEMORY_IMPORT_HANDLE_TYPES_KHR, handle_type_size, handle_type, NULL);

	if (CL_SUCCESS != errNum) {
		printf(" Unable to query CL_DEVICE_EXTERNAL_MEMORY_IMPORT_HANDLE_TYPES_KHR \n");
		return errNum;
	}

	for (i = 0; i < handle_type_size; i++)
	{
		if (requiredHandleType == handle_type[i]) {
			return CL_SUCCESS;
		}
	}
	printf(" cl_khr_external_memory extension is missing support for %d\n",
		requiredHandleType);

	return CL_INVALID_VALUE;
}

cl_int check_external_semaphore_handle_type(cl_device_id deviceID, cl_external_semaphore_handle_type_khr requiredHandleType)
{
	unsigned int i;
	cl_external_semaphore_handle_type_khr* handle_type;
	size_t handle_type_size = 0;
	cl_int errNum = CL_SUCCESS;

	errNum = clGetDeviceInfo(deviceID, CL_DEVICE_SEMAPHORE_IMPORT_HANDLE_TYPES_KHR, 0, NULL, &handle_type_size);
	handle_type = (cl_external_semaphore_handle_type_khr*)malloc(handle_type_size);

	errNum = clGetDeviceInfo(deviceID, CL_DEVICE_SEMAPHORE_IMPORT_HANDLE_TYPES_KHR, handle_type_size, handle_type, NULL);
	if (CL_SUCCESS != errNum) {
		printf(" Unable to query CL_DEVICE_EXTERNAL_SEMAPHORE_IMPORT_HANDLE_TYPES_KHR \n");
		return errNum;
	}

	for (i = 0; i < handle_type_size; i++)
	{
		if (requiredHandleType == handle_type[i]) {
			return CL_SUCCESS;
		}
	}
	printf(" cl_khr_external_semaphore extension is missing support for %d\n",
		requiredHandleType);

	return CL_INVALID_VALUE;
}

VkResult CreateDebugUtilsMessengerEXT(
	VkInstance instance, const VkDebugUtilsMessengerCreateInfoEXT* pCreateInfo,
	const VkAllocationCallbacks* pAllocator,
	VkDebugUtilsMessengerEXT* pDebugMessenger) {
	auto func = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(
		instance, "vkCreateDebugUtilsMessengerEXT");
	if (func != nullptr) {
		return func(instance, pCreateInfo, pAllocator, pDebugMessenger);
	}
	else {
		return VK_ERROR_EXTENSION_NOT_PRESENT;
	}
};

const std::vector<const char*> deviceExtensions = {
	VK_KHR_SWAPCHAIN_EXTENSION_NAME,
	VK_KHR_EXTERNAL_MEMORY_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_EXTENSION_NAME,
#ifdef _WIN32
	VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME,
#else
	VK_KHR_EXTERNAL_MEMORY_FD_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_FD_EXTENSION_NAME,
#endif
};

#ifdef _WIN32
class WindowsSecurityAttributes {
protected:
	SECURITY_ATTRIBUTES m_winSecurityAttributes;
	PSECURITY_DESCRIPTOR m_winPSecurityDescriptor;

public:
	WindowsSecurityAttributes();
	SECURITY_ATTRIBUTES* operator&();
	~WindowsSecurityAttributes();
};

WindowsSecurityAttributes::WindowsSecurityAttributes() {
	m_winPSecurityDescriptor = (PSECURITY_DESCRIPTOR)calloc(
		1, SECURITY_DESCRIPTOR_MIN_LENGTH + 2 * sizeof(void**));

	PSID* ppSID =
		(PSID*)((PBYTE)m_winPSecurityDescriptor + SECURITY_DESCRIPTOR_MIN_LENGTH);
	PACL* ppACL = (PACL*)((PBYTE)ppSID + sizeof(PSID*));

	InitializeSecurityDescriptor(m_winPSecurityDescriptor,
		SECURITY_DESCRIPTOR_REVISION);

	SID_IDENTIFIER_AUTHORITY sidIdentifierAuthority =
		SECURITY_WORLD_SID_AUTHORITY;
	AllocateAndInitializeSid(&sidIdentifierAuthority, 1, SECURITY_WORLD_RID, 0, 0,
		0, 0, 0, 0, 0, ppSID);

	EXPLICIT_ACCESS explicitAccess;
	ZeroMemory(&explicitAccess, sizeof(EXPLICIT_ACCESS));
	explicitAccess.grfAccessPermissions =
		STANDARD_RIGHTS_ALL | SPECIFIC_RIGHTS_ALL;
	explicitAccess.grfAccessMode = SET_ACCESS;
	explicitAccess.grfInheritance = INHERIT_ONLY;
	explicitAccess.Trustee.TrusteeForm = TRUSTEE_IS_SID;
	explicitAccess.Trustee.TrusteeType = TRUSTEE_IS_WELL_KNOWN_GROUP;
	explicitAccess.Trustee.ptstrName = (LPTSTR)*ppSID;

	SetEntriesInAcl(1, &explicitAccess, NULL, ppACL);

	SetSecurityDescriptorDacl(m_winPSecurityDescriptor, TRUE, *ppACL, FALSE);

	m_winSecurityAttributes.nLength = sizeof(m_winSecurityAttributes);
	m_winSecurityAttributes.lpSecurityDescriptor = m_winPSecurityDescriptor;
	m_winSecurityAttributes.bInheritHandle = TRUE;
}

SECURITY_ATTRIBUTES* WindowsSecurityAttributes::operator&() {
	return &m_winSecurityAttributes;
}

WindowsSecurityAttributes::~WindowsSecurityAttributes() {
	PSID* ppSID =
		(PSID*)((PBYTE)m_winPSecurityDescriptor + SECURITY_DESCRIPTOR_MIN_LENGTH);
	PACL* ppACL = (PACL*)((PBYTE)ppSID + sizeof(PSID*));

	if (*ppSID) {
		FreeSid(*ppSID);
	}
	if (*ppACL) {
		LocalFree(*ppACL);
	}
	free(m_winPSecurityDescriptor);
}
#endif

void DestroyDebugUtilsMessengerEXT(VkInstance instance,
	VkDebugUtilsMessengerEXT debugMessenger,
	const VkAllocationCallbacks* pAllocator) {
	auto func = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(
		instance, "vkDestroyDebugUtilsMessengerEXT");
	if (func != nullptr) {
		func(instance, debugMessenger, pAllocator);
	}
}

struct QueueFamilyIndices {
	int graphicsFamily = -1;
	int presentFamily = -1;

	bool isComplete() { return graphicsFamily >= 0 && presentFamily >= 0; }
};

struct SwapChainSupportDetails {
	VkSurfaceCapabilitiesKHR capabilities;
	std::vector<VkSurfaceFormatKHR> formats;
	std::vector<VkPresentModeKHR> presentModes;
};

typedef float vec2[2];

struct Vertex {
	vec4 pos;
	vec3 color;
	vec2 texCoord;

	static VkVertexInputBindingDescription getBindingDescription() {
		VkVertexInputBindingDescription bindingDescription = {};
		bindingDescription.binding = 0;
		bindingDescription.stride = sizeof(Vertex);
		bindingDescription.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;

		return bindingDescription;
	}

	static std::array<VkVertexInputAttributeDescription, 3>
		getAttributeDescriptions() {
		std::array<VkVertexInputAttributeDescription, 3> attributeDescriptions = {};

		attributeDescriptions[0].binding = 0;
		attributeDescriptions[0].location = 0;
		attributeDescriptions[0].format = VK_FORMAT_R32G32B32A32_SFLOAT;
		attributeDescriptions[0].offset = offsetof(Vertex, pos);

		attributeDescriptions[1].binding = 0;
		attributeDescriptions[1].location = 1;
		attributeDescriptions[1].format = VK_FORMAT_R32G32B32_SFLOAT;
		attributeDescriptions[1].offset = offsetof(Vertex, color);

		attributeDescriptions[2].binding = 0;
		attributeDescriptions[2].location = 2;
		attributeDescriptions[2].format = VK_FORMAT_R32G32_SFLOAT;
		attributeDescriptions[2].offset = offsetof(Vertex, texCoord);

		return attributeDescriptions;
	}
};

struct UniformBufferObject {
	alignas(16) mat4x4 model;
	alignas(16) mat4x4 view;
	alignas(16) mat4x4 proj;
};

const std::vector<Vertex> vertices = {
	{{-1.0f, -1.0f, 0.0f, 1.0f}, {1.0f, 0.0f, 0.0f}, {0.0f, 0.0f}},
	{{1.0f, -1.0f, 0.0f, 1.0f}, {0.0f, 1.0f, 0.0f}, {1.0f, 0.0f}},
	{{1.0f, 1.0f, 0.0f, 1.0f}, {0.0f, 0.0f, 1.0f}, {1.0f, 1.0f}},
	{{-1.0f, 1.0f, 0.0f, 1.0f}, {1.0f, 1.0f, 1.0f}, {0.0f, 1.0f}} };

const std::vector<uint16_t> indices = { 0, 1, 2, 2, 3, 0 };

unsigned int filter_radius = 14;
unsigned int g_nFilterSign = 1;

// This varies the filter radius, so we can see automatic animation
void varySigma() {
	filter_radius += g_nFilterSign;

	if (filter_radius > 64) {
		filter_radius = 64;  // clamp to 64 and then negate sign
		g_nFilterSign = -1;
	}
	else if (filter_radius == 0) {
		g_nFilterSign = 1;
	}
}
const char* kernel_text1 = " \
uint4 rgbaFloat4ToUint4(float4 rgba, float fScale)\n\
{\n\
	uint4 uiPackedPix = 0;\n\
	uiPackedPix.x = (unsigned int)(rgba.x * fScale);\n\
	uiPackedPix.y = (unsigned int)(rgba.y * fScale);\n\
	uiPackedPix.z = (unsigned int)(rgba.z * fScale);\n\
	uiPackedPix.w = (unsigned int)(rgba.w * fScale);\n\
	return uiPackedPix;\n\
}\n\
__constant sampler_t RowSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;\n\
__kernel void d_boxfilter_rgba_x(write_only image2d_t  uiDest, \n\
                                  read_only image2d_t SourceRgbaTex, \n\
                                 unsigned int uiWidth, unsigned int uiHeight, \n\
								 unsigned int mipLevels, unsigned int iRadius) \n\
{ \n\
  // Row to process (note:  1 dimensional workgroup and ND range used for row kernel)\n\
	float fScale = 1.0f/(2.0f * iRadius + 1.0f);\n\
	unsigned int globalPosY = get_global_id(0);\n\
    unsigned int szBaseOffset = mul24(globalPosY, uiWidth);\n\
    \n\
    // Process the row as long as Y pos isn'f4Sum off the image\n\
    if (globalPosY < uiHeight)\n\
	{\n\
		// 4 fp32 accumulators\n\
		float4 f4Sum = (float4)0.0f;\n\
		\n\
// Do the left boundary--------------------------------------\n\
		for ( int x = -iRadius; x <=(int)iRadius; x++)   \n\
		{\n\
			int2 pos = { x , globalPosY };\n\
			f4Sum += convert_float4(read_imageui(SourceRgbaTex, RowSampler, pos));\n\
		}\n\
		uint4 result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
        write_imageui(uiDest, (int2)(0, globalPosY), result);\n\
\n\
// Do the rest of the image-----------------------------------\n\
		int2 pos = { 0, globalPosY };\n\
		for (unsigned int x = 1; x < uiWidth ; x++)     \n\
        {\n\
			pos.x = x + iRadius;\n\
			f4Sum += convert_float4(read_imageui(SourceRgbaTex, RowSampler, pos));\n\
			pos.x = x - iRadius - 1;\n\
			f4Sum -= convert_float4(read_imageui(SourceRgbaTex, RowSampler, pos));\n\
			result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
            write_imageui(uiDest, (int2)(x, globalPosY), result);\n\
		}\n\
	}\n\
}\n\
 ";

const char* kernel_text2 = " \
uint4 rgbaFloat4ToUint4(float4 rgba, float fScale)\n\
{\n\
	uint4 uiPackedPix = 0;\n\
	uiPackedPix.x = (unsigned int)(rgba.x * fScale);\n\
	uiPackedPix.y = (unsigned int)(rgba.y * fScale);\n\
	uiPackedPix.z = (unsigned int)(rgba.z * fScale);\n\
	uiPackedPix.w = (unsigned int)(rgba.w * fScale);\n\
	return uiPackedPix;\n\
}\n\
__constant sampler_t Sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;\n\
__kernel void d_boxfilter_rgba_y(write_only image2d_t uiOutputImage,               \n\
                                 read_only image2d_t uiInputImage,			    \n\
                                   unsigned int uiWidth, unsigned int uiHeight,    		        \n\
                                   unsigned int mipLevels, unsigned int iRadius) {  	            \n\
    float fScale = 1.0f/(2.0f * iRadius + 1.0f);\n\
    unsigned int  globalPosX = get_global_id(0); \n\
    uint4 result; \n\
    float4 f4Sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);\n\
    int2 pos = { globalPosX, 0}; \n\
// Do left edge---------------------------------------------------------\n\
	f4Sum = convert_float4(read_imageui(uiInputImage, Sampler, pos)) * (float4)(iRadius);\n\
	for (int y = 0; y < (int)(iRadius + 1); y++)                                         \n\
	{   pos.y =  y;                                                                  \n\
		f4Sum += convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
	}                                                                                    \n\
	result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
    pos.y = 0;\n\
	write_imageui(uiOutputImage, pos, result); \n\
	for (int y = 1; y < (int)(iRadius + 1); y++)\n\
	{\n\
        pos.y  = y + iRadius;\n\
		f4Sum += convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
        pos.y  = 0;\n\
		f4Sum -= convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
		result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
        pos.y =  y;\n\
		write_imageui(uiOutputImage, pos, result);\n\
	}  \n\
// Main loop---------------------------------------------------------------\n\
	for (int y = iRadius + 1; y < (uiHeight - iRadius); y++)\n\
	{\n\
        pos.y = y + iRadius;\n\
		f4Sum += convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
        pos.y = y - iRadius - 1;\n\
		f4Sum -= convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
		result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
        pos.y = y;\n\
		write_imageui(uiOutputImage, pos, result);\n\
	}\n\
// Do right edge-------------------------------------------------------------\n\
    for (int y = uiHeight - iRadius; y < (int)uiHeight; y++)\n\
	{\n\
        pos.y = uiHeight - 1;\n\
		f4Sum += convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
		pos.y = y - iRadius - 1;\n\
	    f4Sum -= convert_float4(read_imageui(uiInputImage, Sampler, pos));\n\
		result = rgbaFloat4ToUint4(f4Sum, fScale);\n\
        pos.y = y ; \n\
		write_imageui(uiOutputImage, pos, result);\n\
	}      \n\
}\n\
";

const char* kernel_text3 = " \
__constant sampler_t smpImg = CLK_NORMALIZED_COORDS_FALSE|CLK_ADDRESS_REPEAT|CLK_FILTER_NEAREST;\n\
__kernel void d_copykernel(write_only image2d_t outputImage,				\n\
						   read_only image2d_t inputImage) { \n\
    unsigned int gX = get_global_id(0), \n\
	gY = get_global_id(1); \n\
    uint4 color; \n\
	color = read_imageui(inputImage, smpImg, (int2)(gX, gY)); \n\
    color.w = 1; \n\
    write_imageui(outputImage, (int2)(gX, gY), color); \n\
}																						\n\
";

class vulkanImageOpenCL {
public:
	void loadImageData(const std::string& filename) {
		// load image (needed so we can get the width and height before we create
		// the window
		char* image_path =
			sdkFindFilePath(filename.c_str(), execution_path.c_str());

		if (image_path == 0) {
			printf("Error finding image file '%s'\n", filename.c_str());
			exit(EXIT_FAILURE);
		}

		sdkLoadPPM4(image_path, (unsigned char**)&image_data, &imageWidth,
			&imageHeight);

		if (!image_data) {
			printf("Error opening file '%s'\n", image_path);
			exit(EXIT_FAILURE);
		}

		printf("Loaded '%s', %d x %d pixels\n", image_path, imageWidth,
			imageHeight);
	}

	void run() {
		initWindow();
		initVulkan();
		initOpenCL();
		mainLoop();
		cleanup();
	}

private:
	GLFWwindow* window;

	VkInstance instance;
	VkDebugUtilsMessengerEXT debugMessenger;
	VkSurfaceKHR surface;

	VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
	VkDevice device;
	uint8_t vkDeviceUUID[VK_UUID_SIZE];

	VkQueue graphicsQueue;
	VkQueue presentQueue;

	VkSwapchainKHR swapChain;
	std::vector<VkImage> swapChainImages;
	VkFormat swapChainImageFormat;
	VkExtent2D swapChainExtent;
	std::vector<VkImageView> swapChainImageViews;
	std::vector<VkFramebuffer> swapChainFramebuffers;

	VkRenderPass renderPass;
	VkDescriptorSetLayout descriptorSetLayout;
	VkPipelineLayout pipelineLayout;
	VkPipeline graphicsPipeline;

	VkCommandPool commandPool;

	VkImage textureImage;
	VkDeviceMemory textureImageMemory;
	VkImageView textureImageView;
	VkSampler textureSampler;

	VkBuffer vertexBuffer;
	VkDeviceMemory vertexBufferMemory;
	VkBuffer indexBuffer;
	VkDeviceMemory indexBufferMemory;

	std::vector<VkBuffer> uniformBuffers;
	std::vector<VkDeviceMemory> uniformBuffersMemory;

	VkDescriptorPool descriptorPool;
	std::vector<VkDescriptorSet> descriptorSets;

	std::vector<VkCommandBuffer> commandBuffers;

	std::vector<VkSemaphore> imageAvailableSemaphores;
	std::vector<VkSemaphore> renderFinishedSemaphores;
	VkSemaphore clUpdateVkSemaphore, vkUpdateclSemaphore;
	std::vector<VkFence> inFlightFences;

	size_t currentFrame = 0;

	bool framebufferResized = false;

#ifdef _WIN32
	PFN_vkGetMemoryWin32HandleKHR fpGetMemoryWin32HandleKHR;
	PFN_vkGetSemaphoreWin32HandleKHR fpGetSemaphoreWin32HandleKHR;
#else
	PFN_vkGetMemoryFdKHR fpGetMemoryFdKHR = NULL;
	PFN_vkGetSemaphoreFdKHR fpGetSemaphoreFdKHR = NULL;
#endif

	PFN_vkGetPhysicalDeviceProperties2 fpGetPhysicalDeviceProperties2;

	unsigned int* image_data = NULL;
	unsigned int imageWidth, imageHeight;
	unsigned int mipLevels;
	size_t totalImageMemSize;

	//OpenCL stuff
	cl_context context = NULL;
	cl_command_queue cmd_queue = NULL;
	cl_mem img1;
	cl_mem img2;
	cl_mem img3;
	unsigned int flag = 0;
	cl_semaphore_khr clOpenCLUpdateVkVertexBufSemaphore;
	cl_semaphore_khr clVkUpdateOpenCLVertexBufSemaphore;
	VkMemoryAllocateInfo allocInfo = {};

	void initWindow() {
		glfwInit();

		glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);

		window = glfwCreateWindow(WIDTH, HEIGHT, "Vulkan Image OpenCL Box Filter",
			nullptr, nullptr);
		glfwSetWindowUserPointer(window, this);
		glfwSetFramebufferSizeCallback(window, framebufferResizeCallback);
	}

	static void framebufferResizeCallback(GLFWwindow* window, int width,
		int height) {
		auto app =
			reinterpret_cast<vulkanImageOpenCL*>(glfwGetWindowUserPointer(window));
		app->framebufferResized = true;
	}

	void initVulkan() {
		createInstance();
		setupDebugMessenger();
		createSurface();
		pickPhysicalDevice();
		createLogicalDevice();
		getKhrExtensionsFn();
		createSwapChain();
		createImageViews();
		createRenderPass();
		createDescriptorSetLayout();
		createGraphicsPipeline();
		createFramebuffers();
		createCommandPool();
		createTextureImage();
		createTextureImageView();
		createTextureSampler();
		createVertexBuffer();
		createIndexBuffer();
		createUniformBuffers();
		createDescriptorPool();
		createDescriptorSets();
		createCommandBuffers();
		createSyncObjects();
		createSyncObjectsExt();
	}

	void initOpenCL() {
		setOpenCLVkDevice();
		getOpenCLFuncAdd();
		openCLVkImportImageMem();
		openCLVkImportSemaphore();
	}

	void mainLoop() {
		updateUniformBuffer();
		
		unsigned int ntimes = 0;
		clock_t start = clock();
		while (!glfwWindowShouldClose(window) && ntimes < maxFrames) {
			glfwPollEvents();
			drawFrame();
			ntimes++;
		}
		clock_t end = clock();
		float time_spent = (float)(end - start) / CLOCKS_PER_SEC;
		float frames_per_sec = ntimes / time_spent;
		printf("numbr of frames per second is %f", frames_per_sec);

		vkDeviceWaitIdle(device);
	}

	void cleanupSwapChain() {
		for (auto framebuffer : swapChainFramebuffers) {
			vkDestroyFramebuffer(device, framebuffer, nullptr);
		}

		vkFreeCommandBuffers(device, commandPool,
			static_cast<uint32_t>(commandBuffers.size()),
			commandBuffers.data());

		vkDestroyPipeline(device, graphicsPipeline, nullptr);
		vkDestroyPipelineLayout(device, pipelineLayout, nullptr);
		vkDestroyRenderPass(device, renderPass, nullptr);

		for (auto imageView : swapChainImageViews) {
			vkDestroyImageView(device, imageView, nullptr);
		}

		vkDestroySwapchainKHR(device, swapChain, nullptr);

		for (size_t i = 0; i < swapChainImages.size(); i++) {
			vkDestroyBuffer(device, uniformBuffers[i], nullptr);
			vkFreeMemory(device, uniformBuffersMemory[i], nullptr);
		}

		vkDestroyDescriptorPool(device, descriptorPool, nullptr);
	}

	void cleanup() {
		cleanupSwapChain();

		vkDestroySampler(device, textureSampler, nullptr);
		vkDestroyImageView(device, textureImageView, nullptr);

		vkDestroyImage(device, textureImage, nullptr);
		vkFreeMemory(device, textureImageMemory, nullptr);

		vkDestroyDescriptorSetLayout(device, descriptorSetLayout, nullptr);

		vkDestroyBuffer(device, indexBuffer, nullptr);
		vkFreeMemory(device, indexBufferMemory, nullptr);

		vkDestroyBuffer(device, vertexBuffer, nullptr);
		vkFreeMemory(device, vertexBufferMemory, nullptr);

		for (size_t i = 0; i < MAX_FRAMES; i++) {
			vkDestroySemaphore(device, renderFinishedSemaphores[i], nullptr);
			vkDestroySemaphore(device, imageAvailableSemaphores[i], nullptr);
			vkDestroyFence(device, inFlightFences[i], nullptr);
		}
		clReleaseSemaphoreObjectKHRptr = (pfnclReleaseSemaphoreObjectKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clReleaseSemaphoreObjectKHR");
		if (NULL == clReleaseSemaphoreObjectKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clReleaseSemaphoreObjectKHRptr!");
		}
		checkResult(
			clReleaseSemaphoreObjectKHRptr(clOpenCLUpdateVkVertexBufSemaphore), "clReleaseSemaphoreObjectKHR");    checkResult(
				clReleaseSemaphoreObjectKHRptr(clVkUpdateOpenCLVertexBufSemaphore), "clReleaseSemaphoreObjectKHR");
		
		if (clReleaseMemObject(img3) != CL_SUCCESS) {
			throw std::runtime_error("Error: Failed to release mem object");
		}
		if (clReleaseMemObject(img2) != CL_SUCCESS) {
			throw std::runtime_error("Error: Failed to release mem object");
		}
		vkDestroyCommandPool(device, commandPool, nullptr);

		vkDestroyDevice(device, nullptr);

		if (enableValidationLayers) {
			DestroyDebugUtilsMessengerEXT(instance, debugMessenger, nullptr);
		}

		vkDestroySurfaceKHR(instance, surface, nullptr);
		vkDestroyInstance(instance, nullptr);

		glfwDestroyWindow(window);

		glfwTerminate();
	}

	void recreateSwapChain() {
		int width = 0, height = 0;
		while (width == 0 || height == 0) {
			glfwGetFramebufferSize(window, &width, &height);
			glfwWaitEvents();
		}

		vkDeviceWaitIdle(device);

		cleanupSwapChain();

		createSwapChain();
		createImageViews();
		createRenderPass();
		createGraphicsPipeline();
		createFramebuffers();
		createUniformBuffers();
		createDescriptorPool();
		createDescriptorSets();
		createCommandBuffers();
	}

	void createInstance() {
		if (enableValidationLayers && !checkValidationLayerSupport()) {
			throw std::runtime_error(
				"validation layers requested, but not available!");
		}

		VkApplicationInfo appInfo = {};
		appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
		appInfo.pApplicationName = "Vulkan Image OpenCL Interop";
		appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
		appInfo.pEngineName = "No Engine";
		appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
		appInfo.apiVersion = VK_API_VERSION_1_0;

		VkInstanceCreateInfo createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
		createInfo.pApplicationInfo = &appInfo;

		auto extensions = getRequiredExtensions();
		createInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
		createInfo.ppEnabledExtensionNames = extensions.data();

		VkDebugUtilsMessengerCreateInfoEXT debugCreateInfo;
		if (enableValidationLayers) {
			createInfo.enabledLayerCount =
				static_cast<uint32_t>(validationLayers.size());
			createInfo.ppEnabledLayerNames = validationLayers.data();

			populateDebugMessengerCreateInfo(debugCreateInfo);
			createInfo.pNext = (VkDebugUtilsMessengerCreateInfoEXT*)&debugCreateInfo;
		}
		else {
			createInfo.enabledLayerCount = 0;

			createInfo.pNext = nullptr;
		}

		if (vkCreateInstance(&createInfo, nullptr, &instance) != VK_SUCCESS) {
			throw std::runtime_error("failed to create instance!");
		}

		fpGetPhysicalDeviceProperties2 =
			(PFN_vkGetPhysicalDeviceProperties2)vkGetInstanceProcAddr(
				instance, "vkGetPhysicalDeviceProperties2");
		if (fpGetPhysicalDeviceProperties2 == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetPhysicalDeviceProperties2KHR\" not "
				"found.\n");
		}

#ifdef _WIN32
		fpGetMemoryWin32HandleKHR =
			(PFN_vkGetMemoryWin32HandleKHR)vkGetInstanceProcAddr(
				instance, "vkGetMemoryWin32HandleKHR");
		if (fpGetMemoryWin32HandleKHR == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetMemoryWin32HandleKHR\" not "
				"found.\n");
		}
#else
		fpGetMemoryFdKHR = (PFN_vkGetMemoryFdKHR)vkGetInstanceProcAddr(
			instance, "vkGetMemoryFdKHR");
		if (fpGetMemoryFdKHR == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetMemoryFdKHR\" not found.\n");
		}
		else {
			std::cout << "Vulkan proc address for vkGetMemoryFdKHR - "
				<< fpGetMemoryFdKHR << std::endl;
		}
#endif
	}

	void populateDebugMessengerCreateInfo(
		VkDebugUtilsMessengerCreateInfoEXT& createInfo) {
		createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
		createInfo.messageSeverity =
			VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
			VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
			VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
		createInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
			VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
			VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
		createInfo.pfnUserCallback = debugCallback;
	}

	void setupDebugMessenger() {
		if (!enableValidationLayers) return;

		VkDebugUtilsMessengerCreateInfoEXT createInfo;
		populateDebugMessengerCreateInfo(createInfo);

		if (CreateDebugUtilsMessengerEXT(instance, &createInfo, nullptr,
			&debugMessenger) != VK_SUCCESS) {
			throw std::runtime_error("failed to set up debug messenger!");
		}
	}

	void createSurface() {
		if (glfwCreateWindowSurface(instance, window, nullptr, &surface) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create window surface!");
		}
	}

	void pickPhysicalDevice() {
		uint32_t deviceCount = 0;
		vkEnumeratePhysicalDevices(instance, &deviceCount, nullptr);

		if (deviceCount == 0) {
			throw std::runtime_error("failed to find GPUs with Vulkan support!");
		}

		std::vector<VkPhysicalDevice> devices(deviceCount);
		vkEnumeratePhysicalDevices(instance, &deviceCount, devices.data());

		for (const auto& device : devices) {
			if (isDeviceSuitable(device)) {
				physicalDevice = device;
				break;
			}
		}

		if (physicalDevice == VK_NULL_HANDLE) {
			throw std::runtime_error("failed to find a suitable GPU!");
		}

		std::cout << "Selected physical device = " << physicalDevice << std::endl;

		VkPhysicalDeviceIDProperties vkPhysicalDeviceIDProperties = {};
		vkPhysicalDeviceIDProperties.sType =
			VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES;
		vkPhysicalDeviceIDProperties.pNext = NULL;

		VkPhysicalDeviceProperties2 vkPhysicalDeviceProperties2 = {};
		vkPhysicalDeviceProperties2.sType =
			VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2;
		vkPhysicalDeviceProperties2.pNext = &vkPhysicalDeviceIDProperties;

		fpGetPhysicalDeviceProperties2(physicalDevice,
			&vkPhysicalDeviceProperties2);

		memcpy(vkDeviceUUID, vkPhysicalDeviceIDProperties.deviceUUID,
			sizeof(vkDeviceUUID));
	}

	void getKhrExtensionsFn() {
#ifdef _WIN32

		fpGetSemaphoreWin32HandleKHR =
			(PFN_vkGetSemaphoreWin32HandleKHR)vkGetDeviceProcAddr(
				device, "vkGetSemaphoreWin32HandleKHR");
		if (fpGetSemaphoreWin32HandleKHR == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetSemaphoreWin32HandleKHR\" not "
				"found.\n");
		}
#else
		fpGetSemaphoreFdKHR = (PFN_vkGetSemaphoreFdKHR)vkGetDeviceProcAddr(
			device, "vkGetSemaphoreFdKHR");
		if (fpGetSemaphoreFdKHR == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetSemaphoreFdKHR\" not found.\n");
		}
#endif
	}

	void getOpenCLFuncAdd() {


		clCreateSemaphoreWithPropertiesKHRptr = (pfnclCreateSemaphoreWithPropertiesKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clCreateSemaphoreWithPropertiesKHR");
		if (!clCreateSemaphoreWithPropertiesKHRptr) {
			throw std::runtime_error("Do not find clCreateSemaphoreWithPropertiesKHR!");
		}

		clEnqueueWaitSemaphoresKHRptr = (pfnclEnqueueWaitSemaphoresKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueWaitSemaphoresKHR");
		if (!clEnqueueWaitSemaphoresKHRptr) {
			throw std::runtime_error("Do not find clEnqueueWaitSemaphoresKHR");
		}

		clEnqueueSignalSemaphoresKHRptr = (pfnclEnqueueSignalSemaphoresKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueSignalSemaphoresKHR");
		if (!clEnqueueSignalSemaphoresKHRptr) {
			throw std::runtime_error("Do not find clEnqueueSignalSemaphoresKHR");
		}

		clEnqueueAcquireExternalMemObjectsKHRptr = (pfnclEnqueueAcquireExternalMemObjectsKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueAcquireExternalMemObjectsKHR");
		if (!clEnqueueAcquireExternalMemObjectsKHRptr) {
			throw std::runtime_error("Do not find clEnqueueAcquireExternalMemObjectsKHR");
		}

		clEnqueueReleaseExternalMemObjectsKHRptr = (pfnclEnqueueReleaseExternalMemObjectsKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueReleaseExternalMemObjectsKHR");
		if (!clEnqueueReleaseExternalMemObjectsKHRptr) {
			throw std::runtime_error("Do not find clEnqueueReleaseExternalMemObjectsKHRptr");
		}
	}
	void setOpenCLVkDevice() {

		cl_int errNum;
		cl_uint num_platforms = 0, i = 0;
		cl_platform_id* platforms = NULL;
		size_t extensionSize = 0;
		cl_uint num_devices = 0;
		cl_uint device_no = 0;
		const size_t bufsize = BUFFERSIZE;
		char buf[BUFFERSIZE];
		cl_device_id* devices;
		char* extensions = NULL;

		cl_context_properties contextProperties[] =
		{
			CL_CONTEXT_PLATFORM,
			0,
			0
		};

		errNum = clGetPlatformIDs(0, NULL, &num_platforms);
		if (errNum != CL_SUCCESS) {
			throw std::runtime_error("Error: Failed to get number of platform");
		}

		platforms = (cl_platform_id*)malloc(num_platforms * sizeof(cl_platform_id));
		if (!platforms) {
			throw std::runtime_error("error allocating memory");
		}

		// get the platform ID
		errNum = clGetPlatformIDs(num_platforms, platforms, NULL);
		if (errNum != CL_SUCCESS) {
			throw std::runtime_error("Error: Failed to get platform");
		}

		//Search for nvidia platform
		for (i = 0; i < num_platforms; i++) {
			//get platform information
			errNum = clGetPlatformInfo(platforms[i], CL_PLATFORM_VENDOR, bufsize, buf, NULL);
			if (CL_SUCCESS != errNum) {
				throw std::runtime_error("Error:Failed to get platform info");
			}
			if (NULL != strstr(buf, "NVIDIA Corporation")) {
				printf("found Nvidia platform\n");
				break;
			}
		}

		// Check whether there is any nvidia platform or not
		if (i >= num_platforms) {
			throw std::runtime_error("No NVIDIA platform found");
		}

		opencl_platform = platforms[i];
		contextProperties[1] = (cl_context_properties)platforms[i];

		errNum = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, 0, NULL, &num_devices);
		if (CL_SUCCESS != errNum) {
			throw std::runtime_error("clGetDeviceIDs failed in returning of devices");
		}
		devices = (cl_device_id*)malloc(num_devices * sizeof(cl_device_id));

		errNum = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, num_devices, devices, NULL);
		if (CL_SUCCESS != errNum) {
			throw std::runtime_error("Failed to get deviceID.");
		}

		for (device_no = 0; device_no < num_devices; device_no++) {
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_EXTENSIONS, 0, NULL, &extensionSize);
			extensions = (char*)malloc(extensionSize);
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_EXTENSIONS, extensionSize, extensions, NULL);
			if (CL_SUCCESS != errNum) {
				throw std::runtime_error("Error in clGetDeviceInfo for getting device_extension");
			}
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_UUID_KHR, CL_UUID_SIZE_KHR, uuid, &extensionSize);
			if (CL_SUCCESS != errNum) {
				throw std::runtime_error("Error in clGetDeviceInfo");
			}
			errNum = memcmp(&uuid, &vkDeviceUUID, VK_UUID_SIZE);
			if (errNum == 0) {
				break;
			}
		}
		if (device_no >= num_devices) {
			fprintf(stderr, "OpenCL error:"
				" No Vulkan-OpenCL Interop capable GPU found.\n");
			exit(EXIT_FAILURE);
		}
		deviceId = devices[device_no];

		if (!(isExtensionAvailable(devices[device_no], "cl_khr_external_memory") && isExtensionAvailable(devices[device_no], "cl_khr_external_semaphore"))) {
			printf(" Device does not support cl_khr_external_memory or cl_khr_external_semaphore extension\n");
			exit(EXIT_FAILURE);
		}
		context = clCreateContextFromType(contextProperties, CL_DEVICE_TYPE_GPU,
			NULL, NULL, &errNum);

		//check for errNum$
		if (CL_SUCCESS != errNum) {
			printf("clCreateContextFromType failed with error=%d\n", errNum);
			throw std::runtime_error("");
		}

		cmd_queue = clCreateCommandQueue(context, deviceId, 0, NULL);
		if (cmd_queue == (cl_command_queue)0) {
			throw std::runtime_error("Error: Failed to create command queue!\n");
		}

		program_source_const = kernel_text1;
		program_source_length = strlen(program_source_const);
		program = clCreateProgramWithSource(
			context,
			1,
			&program_source_const,
			&program_source_length,
			&errNum);

		errNum = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

		if (errNum != CL_SUCCESS)
		{
			printf("clBuildprogram failed for kernel-1 with error=%d\n", errNum);
			throw std::runtime_error("");
		}
		// create the kernel_1
		kernel_1 = clCreateKernel(program, "d_boxfilter_rgba_x", &errNum);
		if (0 != checkResult(errNum, "clCreateKernel"))
		{
			throw std::runtime_error("clCreateKernel failed!!!");
		}

		program_source_const = kernel_text2;
		program_source_length = strlen(program_source_const);
		program = clCreateProgramWithSource(
			context,
			1,
			&program_source_const,
			&program_source_length,
			&errNum);

		errNum = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

		if (errNum != CL_SUCCESS)
		{
			printf("clBuildprogram failed for kernel-2 with error=%d\n", errNum);
			throw std::runtime_error("");
		}
		kernel_2 = clCreateKernel(program, "d_boxfilter_rgba_y", &errNum);
		if (0 != checkResult(errNum, "clCreateKernel"))
		{
			throw std::runtime_error("clCreateKernel failed!!!");
		}
		// CopyKernel
		program_source_const = kernel_text3;
		program_source_length = strlen(program_source_const);
		program = clCreateProgramWithSource(
			context,
			1,
			&program_source_const,
			&program_source_length,
			&errNum);

		errNum = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

		if (errNum != CL_SUCCESS)
		{
			printf("clBuildprogram failed for kernel-3 with error=%d\n", errNum);
			throw std::runtime_error("");
		}
		kernel_3 = clCreateKernel(program, "d_copykernel", &errNum);
		if (0 != checkResult(errNum, "clCreateKernel"))
		{
			throw std::runtime_error("clCreateKernel failed!!!");
		}
	}

	void createLogicalDevice() {
		QueueFamilyIndices indices = findQueueFamilies(physicalDevice);

		std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
		std::set<int> uniqueQueueFamilies = { indices.graphicsFamily,
											 indices.presentFamily };

		float queuePriority = 1.0f;
		for (int queueFamily : uniqueQueueFamilies) {
			VkDeviceQueueCreateInfo queueCreateInfo = {};
			queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
			queueCreateInfo.queueFamilyIndex = queueFamily;
			queueCreateInfo.queueCount = 1;
			queueCreateInfo.pQueuePriorities = &queuePriority;
			queueCreateInfos.push_back(queueCreateInfo);
		}

		VkPhysicalDeviceFeatures deviceFeatures = {};

		VkDeviceCreateInfo createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;

		createInfo.pQueueCreateInfos = queueCreateInfos.data();
		createInfo.queueCreateInfoCount = queueCreateInfos.size();

		createInfo.pEnabledFeatures = &deviceFeatures;
		std::vector<const char*> enabledExtensionNameList;

		for (int i = 0; i < deviceExtensions.size(); i++) {
			enabledExtensionNameList.push_back(deviceExtensions[i]);
		}
		if (enableValidationLayers) {
			createInfo.enabledLayerCount =
				static_cast<uint32_t>(validationLayers.size());
			createInfo.ppEnabledLayerNames = validationLayers.data();
		}
		else {
			createInfo.enabledLayerCount = 0;
		}
		createInfo.enabledExtensionCount =
			static_cast<uint32_t>(enabledExtensionNameList.size());
		createInfo.ppEnabledExtensionNames = enabledExtensionNameList.data();

		if (vkCreateDevice(physicalDevice, &createInfo, nullptr, &device) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create logical device!");
		}
		vkGetDeviceQueue(device, indices.graphicsFamily, 0, &graphicsQueue);
		vkGetDeviceQueue(device, indices.presentFamily, 0, &presentQueue);
	}

	void createSwapChain() {
		SwapChainSupportDetails swapChainSupport =
			querySwapChainSupport(physicalDevice);

		VkSurfaceFormatKHR surfaceFormat =
			chooseSwapSurfaceFormat(swapChainSupport.formats);
		VkPresentModeKHR presentMode =
			chooseSwapPresentMode(swapChainSupport.presentModes);
		VkExtent2D extent = chooseSwapExtent(swapChainSupport.capabilities);

		uint32_t imageCount = swapChainSupport.capabilities.minImageCount + 1;
		if (swapChainSupport.capabilities.maxImageCount > 0 &&
			imageCount > swapChainSupport.capabilities.maxImageCount) {
			imageCount = swapChainSupport.capabilities.maxImageCount;
		}

		VkSwapchainCreateInfoKHR createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
		createInfo.surface = surface;

		createInfo.minImageCount = imageCount;
		createInfo.imageFormat = surfaceFormat.format;
		createInfo.imageColorSpace = surfaceFormat.colorSpace;
		createInfo.imageExtent = extent;
		createInfo.imageArrayLayers = 1;
		createInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;

		QueueFamilyIndices indices = findQueueFamilies(physicalDevice);
		uint32_t queueFamilyIndices[] = { (uint32_t)indices.graphicsFamily,
										 (uint32_t)indices.presentFamily };

		if (indices.graphicsFamily != indices.presentFamily) {
			createInfo.imageSharingMode = VK_SHARING_MODE_CONCURRENT;
			createInfo.queueFamilyIndexCount = 2;
			createInfo.pQueueFamilyIndices = queueFamilyIndices;
		}
		else {
			createInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
		}

		createInfo.preTransform = swapChainSupport.capabilities.currentTransform;
		createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
		createInfo.presentMode = presentMode;
		createInfo.clipped = VK_TRUE;

		if (vkCreateSwapchainKHR(device, &createInfo, nullptr, &swapChain) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create swap chain!");
		}

		vkGetSwapchainImagesKHR(device, swapChain, &imageCount, nullptr);
		swapChainImages.resize(imageCount);
		vkGetSwapchainImagesKHR(device, swapChain, &imageCount,
			swapChainImages.data());

		swapChainImageFormat = surfaceFormat.format;
		swapChainExtent = extent;
	}

	void createImageViews() {
		swapChainImageViews.resize(swapChainImages.size());

		for (size_t i = 0; i < swapChainImages.size(); i++) {
			swapChainImageViews[i] =
				createImageView(swapChainImages[i], swapChainImageFormat);
		}
	}

	void createRenderPass() {
		VkAttachmentDescription colorAttachment = {};
		colorAttachment.format = swapChainImageFormat;
		colorAttachment.samples = VK_SAMPLE_COUNT_1_BIT;
		colorAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
		colorAttachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
		colorAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
		colorAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
		colorAttachment.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
		colorAttachment.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;

		VkAttachmentReference colorAttachmentRef = {};
		colorAttachmentRef.attachment = 0;
		colorAttachmentRef.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

		VkSubpassDescription subpass = {};
		subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
		subpass.colorAttachmentCount = 1;
		subpass.pColorAttachments = &colorAttachmentRef;

		VkSubpassDependency dependency = {};
		dependency.srcSubpass = VK_SUBPASS_EXTERNAL;
		dependency.dstSubpass = 0;
		dependency.srcStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
		dependency.srcAccessMask = 0;
		dependency.dstStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
		dependency.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_READ_BIT |
			VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;

		VkRenderPassCreateInfo renderPassInfo = {};
		renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
		renderPassInfo.attachmentCount = 1;
		renderPassInfo.pAttachments = &colorAttachment;
		renderPassInfo.subpassCount = 1;
		renderPassInfo.pSubpasses = &subpass;
		renderPassInfo.dependencyCount = 1;
		renderPassInfo.pDependencies = &dependency;

		if (vkCreateRenderPass(device, &renderPassInfo, nullptr, &renderPass) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create render pass!");
		}
	}

	void createDescriptorSetLayout() {
		VkDescriptorSetLayoutBinding uboLayoutBinding = {};
		uboLayoutBinding.binding = 0;
		uboLayoutBinding.descriptorCount = 1;
		uboLayoutBinding.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		uboLayoutBinding.pImmutableSamplers = nullptr;
		uboLayoutBinding.stageFlags = VK_SHADER_STAGE_VERTEX_BIT;

		VkDescriptorSetLayoutBinding samplerLayoutBinding = {};
		samplerLayoutBinding.binding = 1;
		samplerLayoutBinding.descriptorCount = 1;
		samplerLayoutBinding.descriptorType =
			VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		samplerLayoutBinding.pImmutableSamplers = nullptr;
		samplerLayoutBinding.stageFlags = VK_SHADER_STAGE_FRAGMENT_BIT;

		std::array<VkDescriptorSetLayoutBinding, 2> bindings = {
			uboLayoutBinding, samplerLayoutBinding };
		VkDescriptorSetLayoutCreateInfo layoutInfo = {};
		layoutInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = static_cast<uint32_t>(bindings.size());
		layoutInfo.pBindings = bindings.data();

		if (vkCreateDescriptorSetLayout(device, &layoutInfo, nullptr,
			&descriptorSetLayout) != VK_SUCCESS) {
			throw std::runtime_error("failed to create descriptor set layout!");
		}
	}

	void createGraphicsPipeline() {
		auto vertShaderCode = readFile("shader.vert");
		auto fragShaderCode = readFile("shader.frag");

		VkShaderModule vertShaderModule = createShaderModule(vertShaderCode);
		VkShaderModule fragShaderModule = createShaderModule(fragShaderCode);

		VkPipelineShaderStageCreateInfo vertShaderStageInfo = {};
		vertShaderStageInfo.sType =
			VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
		vertShaderStageInfo.stage = VK_SHADER_STAGE_VERTEX_BIT;
		vertShaderStageInfo.module = vertShaderModule;
		vertShaderStageInfo.pName = "main";

		VkPipelineShaderStageCreateInfo fragShaderStageInfo = {};
		fragShaderStageInfo.sType =
			VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
		fragShaderStageInfo.stage = VK_SHADER_STAGE_FRAGMENT_BIT;
		fragShaderStageInfo.module = fragShaderModule;
		fragShaderStageInfo.pName = "main";

		VkPipelineShaderStageCreateInfo shaderStages[] = { vertShaderStageInfo,
														  fragShaderStageInfo };

		VkPipelineVertexInputStateCreateInfo vertexInputInfo = {};
		vertexInputInfo.sType =
			VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;

		auto bindingDescription = Vertex::getBindingDescription();
		auto attributeDescriptions = Vertex::getAttributeDescriptions();

		vertexInputInfo.vertexBindingDescriptionCount = 1;
		vertexInputInfo.vertexAttributeDescriptionCount =
			static_cast<uint32_t>(attributeDescriptions.size());
		vertexInputInfo.pVertexBindingDescriptions = &bindingDescription;
		vertexInputInfo.pVertexAttributeDescriptions = attributeDescriptions.data();

		VkPipelineInputAssemblyStateCreateInfo inputAssembly = {};
		inputAssembly.sType =
			VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
		inputAssembly.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
		inputAssembly.primitiveRestartEnable = VK_FALSE;

		VkViewport viewport = {};
		viewport.x = 0.0f;
		viewport.y = 0.0f;
		viewport.width = (float)swapChainExtent.width;
		viewport.height = (float)swapChainExtent.height;
		viewport.minDepth = 0.0f;
		viewport.maxDepth = 1.0f;

		VkRect2D scissor = {};
		scissor.offset = { 0, 0 };
		scissor.extent = swapChainExtent;

		VkPipelineViewportStateCreateInfo viewportState = {};
		viewportState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
		viewportState.viewportCount = 1;
		viewportState.pViewports = &viewport;
		viewportState.scissorCount = 1;
		viewportState.pScissors = &scissor;

		VkPipelineRasterizationStateCreateInfo rasterizer = {};
		rasterizer.sType =
			VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
		rasterizer.depthClampEnable = VK_FALSE;
		rasterizer.rasterizerDiscardEnable = VK_FALSE;
		rasterizer.polygonMode = VK_POLYGON_MODE_FILL;
		rasterizer.lineWidth = 1.0f;
		rasterizer.cullMode = VK_CULL_MODE_BACK_BIT;
		rasterizer.frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE;
		rasterizer.depthBiasEnable = VK_FALSE;

		VkPipelineMultisampleStateCreateInfo multisampling = {};
		multisampling.sType =
			VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
		multisampling.sampleShadingEnable = VK_FALSE;
		multisampling.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;

		VkPipelineColorBlendAttachmentState colorBlendAttachment = {};
		colorBlendAttachment.colorWriteMask =
			VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
			VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
		colorBlendAttachment.blendEnable = VK_FALSE;

		VkPipelineColorBlendStateCreateInfo colorBlending = {};
		colorBlending.sType =
			VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
		colorBlending.logicOpEnable = VK_FALSE;
		colorBlending.logicOp = VK_LOGIC_OP_COPY;
		colorBlending.attachmentCount = 1;
		colorBlending.pAttachments = &colorBlendAttachment;
		colorBlending.blendConstants[0] = 0.0f;
		colorBlending.blendConstants[1] = 0.0f;
		colorBlending.blendConstants[2] = 0.0f;
		colorBlending.blendConstants[3] = 0.0f;

		VkPipelineLayoutCreateInfo pipelineLayoutInfo = {};
		pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
		pipelineLayoutInfo.setLayoutCount = 1;
		pipelineLayoutInfo.pSetLayouts = &descriptorSetLayout;

		if (vkCreatePipelineLayout(device, &pipelineLayoutInfo, nullptr,
			&pipelineLayout) != VK_SUCCESS) {
			throw std::runtime_error("failed to create pipeline layout!");
		}

		VkGraphicsPipelineCreateInfo pipelineInfo = {};
		pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
		pipelineInfo.stageCount = 2;
		pipelineInfo.pStages = shaderStages;
		pipelineInfo.pVertexInputState = &vertexInputInfo;
		pipelineInfo.pInputAssemblyState = &inputAssembly;
		pipelineInfo.pViewportState = &viewportState;
		pipelineInfo.pRasterizationState = &rasterizer;
		pipelineInfo.pMultisampleState = &multisampling;
		pipelineInfo.pColorBlendState = &colorBlending;
		pipelineInfo.layout = pipelineLayout;
		pipelineInfo.renderPass = renderPass;
		pipelineInfo.subpass = 0;
		pipelineInfo.basePipelineHandle = VK_NULL_HANDLE;

		if (vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, &pipelineInfo,
			nullptr, &graphicsPipeline) != VK_SUCCESS) {
			throw std::runtime_error("failed to create graphics pipeline!");
		}

		vkDestroyShaderModule(device, fragShaderModule, nullptr);
		vkDestroyShaderModule(device, vertShaderModule, nullptr);
	}

	void createFramebuffers() {
		swapChainFramebuffers.resize(swapChainImageViews.size());

		for (size_t i = 0; i < swapChainImageViews.size(); i++) {
			VkImageView attachments[] = { swapChainImageViews[i] };

			VkFramebufferCreateInfo framebufferInfo = {};
			framebufferInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
			framebufferInfo.renderPass = renderPass;
			framebufferInfo.attachmentCount = 1;
			framebufferInfo.pAttachments = attachments;
			framebufferInfo.width = swapChainExtent.width;
			framebufferInfo.height = swapChainExtent.height;
			framebufferInfo.layers = 1;

			if (vkCreateFramebuffer(device, &framebufferInfo, nullptr,
				&swapChainFramebuffers[i]) != VK_SUCCESS) {
				throw std::runtime_error("failed to create framebuffer!");
			}
		}
	}

	void createCommandPool() {
		QueueFamilyIndices queueFamilyIndices = findQueueFamilies(physicalDevice);

		VkCommandPoolCreateInfo poolInfo = {};
		poolInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
		poolInfo.queueFamilyIndex = queueFamilyIndices.graphicsFamily;

		if (vkCreateCommandPool(device, &poolInfo, nullptr, &commandPool) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create graphics command pool!");
		}
	}

	void createTextureImage() {
		VkDeviceSize imageSize = imageWidth * imageHeight * 4;
		mipLevels = 1;
		printf("mipLevels = %d\n", mipLevels);

		if (!image_data) {
			throw std::runtime_error("failed to load texture image!");
		}

		VkBuffer stagingBuffer;
		VkDeviceMemory stagingBufferMemory;
		createBuffer(imageSize, VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
			VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
			VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
			stagingBuffer, stagingBufferMemory);

		void* data;
		vkMapMemory(device, stagingBufferMemory, 0, imageSize, 0, &data);
		memcpy(data, image_data, static_cast<size_t>(imageSize));
		vkUnmapMemory(device, stagingBufferMemory);

		// VK_FORMAT_R8G8B8A8_UNORM changed to VK_FORMAT_R8G8B8A8_UINT
		createImage(
			imageWidth, imageHeight, VK_FORMAT_R8G8B8A8_UINT,
			VK_IMAGE_TILING_OPTIMAL,
			VK_IMAGE_USAGE_STORAGE_BIT | VK_IMAGE_USAGE_TRANSFER_SRC_BIT |
			VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT,
			0, textureImage, textureImageMemory);

		transitionImageLayout(textureImage, VK_FORMAT_R8G8B8A8_UINT,
			VK_IMAGE_LAYOUT_UNDEFINED,
			VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);
		copyBufferToImage(stagingBuffer, textureImage,
			static_cast<uint32_t>(imageWidth),
			static_cast<uint32_t>(imageHeight));
		transitionImageLayout(textureImage, VK_FORMAT_R8G8B8A8_UINT,
			VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
			VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);

		vkDestroyBuffer(device, stagingBuffer, nullptr);
		vkFreeMemory(device, stagingBufferMemory, nullptr);

		generateMipmaps(textureImage, VK_FORMAT_R8G8B8A8_UNORM);
	}

	void generateMipmaps(VkImage image, VkFormat imageFormat) {
		VkFormatProperties formatProperties;
		vkGetPhysicalDeviceFormatProperties(physicalDevice, imageFormat,
			&formatProperties);

		if (!(formatProperties.optimalTilingFeatures &
			VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_LINEAR_BIT)) {
			throw std::runtime_error(
				"texture image format does not support linear blitting!");
		}

		VkCommandBuffer commandBuffer = beginSingleTimeCommands();

		VkImageMemoryBarrier barrier = {};
		barrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
		barrier.image = image;
		barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		barrier.subresourceRange.baseArrayLayer = 0;
		barrier.subresourceRange.layerCount = 1;
		barrier.subresourceRange.levelCount = 1;

		int32_t mipWidth = imageWidth;
		int32_t mipHeight = imageHeight;

		for (uint32_t i = 1; i < mipLevels; i++) {
			barrier.subresourceRange.baseMipLevel = i - 1;
			barrier.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
			barrier.newLayout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
			barrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
			barrier.dstAccessMask = VK_ACCESS_TRANSFER_READ_BIT;

			vkCmdPipelineBarrier(commandBuffer, VK_PIPELINE_STAGE_TRANSFER_BIT,
				VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, nullptr, 0,
				nullptr, 1, &barrier);

			VkImageBlit blit = {};
			blit.srcOffsets[0] = { 0, 0, 0 };
			blit.srcOffsets[1] = { mipWidth, mipHeight, 1 };
			blit.srcSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
			blit.srcSubresource.mipLevel = i - 1;
			blit.srcSubresource.baseArrayLayer = 0;
			blit.srcSubresource.layerCount = 1;
			blit.dstOffsets[0] = { 0, 0, 0 };
			blit.dstOffsets[1] = { mipWidth > 1 ? mipWidth / 2 : 1,
								  mipHeight > 1 ? mipHeight / 2 : 1, 1 };
			blit.dstSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
			blit.dstSubresource.mipLevel = i;
			blit.dstSubresource.baseArrayLayer = 0;
			blit.dstSubresource.layerCount = 1;

			vkCmdBlitImage(commandBuffer, image, VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
				image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &blit,
				VK_FILTER_LINEAR);

			barrier.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
			barrier.newLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
			barrier.srcAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
			barrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;

			vkCmdPipelineBarrier(commandBuffer, VK_PIPELINE_STAGE_TRANSFER_BIT,
				VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT, 0, 0, nullptr,
				0, nullptr, 1, &barrier);

			if (mipWidth > 1) mipWidth /= 2;
			if (mipHeight > 1) mipHeight /= 2;
		}

		barrier.subresourceRange.baseMipLevel = mipLevels - 1;
		barrier.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
		barrier.newLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
		barrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
		barrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;

		vkCmdPipelineBarrier(commandBuffer, VK_PIPELINE_STAGE_TRANSFER_BIT,
			VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT, 0, 0, nullptr,
			0, nullptr, 1, &barrier);

		endSingleTimeCommands(commandBuffer);
	}

#ifdef _WIN32  // For windows
	HANDLE getVkImageMemHandle(
		VkExternalMemoryHandleTypeFlagsKHR externalMemoryHandleType) {
		HANDLE handle;

		VkMemoryGetWin32HandleInfoKHR vkMemoryGetWin32HandleInfoKHR = {};
		vkMemoryGetWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
		vkMemoryGetWin32HandleInfoKHR.pNext = NULL;
		vkMemoryGetWin32HandleInfoKHR.memory = textureImageMemory;
		vkMemoryGetWin32HandleInfoKHR.handleType =
			(VkExternalMemoryHandleTypeFlagBitsKHR)externalMemoryHandleType;

		fpGetMemoryWin32HandleKHR(device, &vkMemoryGetWin32HandleInfoKHR, &handle);
		return handle;
	}
	HANDLE getVkSemaphoreHandle(
		VkExternalSemaphoreHandleTypeFlagBitsKHR externalSemaphoreHandleType,
		VkSemaphore& semVkcl) {
		HANDLE handle;

		VkSemaphoreGetWin32HandleInfoKHR vulkanSemaphoreGetWin32HandleInfoKHR = {};
		vulkanSemaphoreGetWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
		vulkanSemaphoreGetWin32HandleInfoKHR.pNext = NULL;
		vulkanSemaphoreGetWin32HandleInfoKHR.semaphore = semVkcl;
		vulkanSemaphoreGetWin32HandleInfoKHR.handleType =
			externalSemaphoreHandleType;

		fpGetSemaphoreWin32HandleKHR(device, &vulkanSemaphoreGetWin32HandleInfoKHR,
			&handle);

		return handle;
	}
#else
	int getVkImageMemHandle(
		VkExternalMemoryHandleTypeFlagsKHR externalMemoryHandleType) {
		if (externalMemoryHandleType ==
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR) {
			int fd;

			VkMemoryGetFdInfoKHR vkMemoryGetFdInfoKHR = {};
			vkMemoryGetFdInfoKHR.sType = VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR;
			vkMemoryGetFdInfoKHR.pNext = NULL;
			vkMemoryGetFdInfoKHR.memory = textureImageMemory;
			vkMemoryGetFdInfoKHR.handleType =
				VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

			fpGetMemoryFdKHR(device, &vkMemoryGetFdInfoKHR, &fd);

			return fd;
		}
		return -1;
	}

	int getVkSemaphoreHandle(
		VkExternalSemaphoreHandleTypeFlagBitsKHR externalSemaphoreHandleType,
		VkSemaphore& semVkcl) {
		if (externalSemaphoreHandleType ==
			VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT) {
			int fd;

			VkSemaphoreGetFdInfoKHR vulkanSemaphoreGetFdInfoKHR = {};
			vulkanSemaphoreGetFdInfoKHR.sType =
				VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR;
			vulkanSemaphoreGetFdInfoKHR.pNext = NULL;
			vulkanSemaphoreGetFdInfoKHR.semaphore = semVkcl;
			vulkanSemaphoreGetFdInfoKHR.handleType =
				VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

			fpGetSemaphoreFdKHR(device, &vulkanSemaphoreGetFdInfoKHR, &fd);

			return fd;
		}
		return -1;
	}
#endif

	void createTextureImageView() {
		textureImageView = createImageView(textureImage, VK_FORMAT_R8G8B8A8_UNORM);
	}

	void createTextureSampler() {
		VkSamplerCreateInfo samplerInfo = {};
		samplerInfo.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
		samplerInfo.magFilter = VK_FILTER_LINEAR;
		samplerInfo.minFilter = VK_FILTER_LINEAR;
		samplerInfo.addressModeU = VK_SAMPLER_ADDRESS_MODE_REPEAT;
		samplerInfo.addressModeV = VK_SAMPLER_ADDRESS_MODE_REPEAT;
		samplerInfo.addressModeW = VK_SAMPLER_ADDRESS_MODE_REPEAT;
		samplerInfo.anisotropyEnable = VK_TRUE;
		samplerInfo.maxAnisotropy = 16;
		samplerInfo.borderColor = VK_BORDER_COLOR_INT_OPAQUE_BLACK;
		samplerInfo.unnormalizedCoordinates = VK_FALSE;
		samplerInfo.compareEnable = VK_FALSE;
		samplerInfo.compareOp = VK_COMPARE_OP_ALWAYS;
		samplerInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_LINEAR;
		samplerInfo.minLod = 0;  // Optional
		samplerInfo.maxLod = static_cast<float>(mipLevels);
		samplerInfo.mipLodBias = 0;  // Optional

		if (vkCreateSampler(device, &samplerInfo, nullptr, &textureSampler) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create texture sampler!");
		}
	}

	VkImageView createImageView(VkImage image, VkFormat format) {
		VkImageViewCreateInfo viewInfo = {};
		viewInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
		viewInfo.image = image;
		viewInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
		viewInfo.format = format;
		viewInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		viewInfo.subresourceRange.baseMipLevel = 0;
		viewInfo.subresourceRange.levelCount = mipLevels;
		viewInfo.subresourceRange.baseArrayLayer = 0;
		viewInfo.subresourceRange.layerCount = 1;

		VkImageView imageView;

		if (vkCreateImageView(device, &viewInfo, nullptr, &imageView) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create texture image view!");
		}
		return imageView;
	}

	void createImage(uint32_t width, uint32_t height, VkFormat format,
		VkImageTiling tiling, VkImageUsageFlags usage,
		VkMemoryPropertyFlags properties, VkImage& image,
		VkDeviceMemory& imageMemory) {
		imageInfo1 = {};
		imageInfo1.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
		imageInfo1.imageType = VK_IMAGE_TYPE_2D;
		imageInfo1.extent.width = width;
		imageInfo1.extent.height = height;
		imageInfo1.extent.depth = 1;
		imageInfo1.mipLevels = mipLevels;
		imageInfo1.arrayLayers = 1;
		imageInfo1.format = format;
		imageInfo1.tiling = tiling;
		imageInfo1.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
		imageInfo1.usage = usage;
		imageInfo1.samples = VK_SAMPLE_COUNT_1_BIT;
		imageInfo1.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

		VkExternalMemoryImageCreateInfo vkExternalMemImageCreateInfo1 = {};
		vkExternalMemImageCreateInfo1.sType =
			VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO;
		vkExternalMemImageCreateInfo1.pNext = NULL;
		vkExternalMemImageCreateInfo1.handleTypes =
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

		imageInfo1.pNext = &vkExternalMemImageCreateInfo1;

		if (vkCreateImage(device, &imageInfo1, nullptr, &image) != VK_SUCCESS) {
			throw std::runtime_error("failed to create image!");
		}

		VkMemoryRequirements memRequirements;
		vkGetImageMemoryRequirements(device, image, &memRequirements);

#ifdef _WIN32
		WindowsSecurityAttributes winSecurityAttributes;

		VkExportMemoryWin32HandleInfoKHR vulkanExportMemoryWin32HandleInfoKHR = {};
		vulkanExportMemoryWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
		vulkanExportMemoryWin32HandleInfoKHR.pNext = NULL;
		vulkanExportMemoryWin32HandleInfoKHR.pAttributes = &winSecurityAttributes;
		vulkanExportMemoryWin32HandleInfoKHR.dwAccess =
			DXGI_SHARED_RESOURCE_READ | DXGI_SHARED_RESOURCE_WRITE;
		vulkanExportMemoryWin32HandleInfoKHR.name = (LPCWSTR)NULL;
#endif
		VkExportMemoryAllocateInfoKHR vulkanExportMemoryAllocateInfoKHR = {};
		vulkanExportMemoryAllocateInfoKHR.sType =
			VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_KHR;
#ifdef _WIN32
		vulkanExportMemoryAllocateInfoKHR.pNext =
			IsWindows8OrGreater() ? &vulkanExportMemoryWin32HandleInfoKHR : NULL;
		vulkanExportMemoryAllocateInfoKHR.handleTypes =
			IsWindows8OrGreater()
			? VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT;
#else
		vulkanExportMemoryAllocateInfoKHR.pNext = NULL;
		vulkanExportMemoryAllocateInfoKHR.handleTypes =
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;
#endif

		VkMemoryAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
		allocInfo.allocationSize = memRequirements.size;
		allocInfo.pNext = &vulkanExportMemoryAllocateInfoKHR;
		allocInfo.memoryTypeIndex =
			findMemoryType(memRequirements.memoryTypeBits, properties);

		VkMemoryRequirements vkMemoryRequirements = {};
		vkGetImageMemoryRequirements(device, image, &vkMemoryRequirements);
		totalImageMemSize = vkMemoryRequirements.size;

		if (vkAllocateMemory(device, &allocInfo, nullptr, &textureImageMemory) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate image memory!");
		}

		vkBindImageMemory(device, image, textureImageMemory, 0);
	}

	void openCLVkImportSemaphore() {

		cl_int err = 0;
		cl_semaphore_desc_khr externalSemaphoreHandleDesc = {};
		void* handle = NULL;
		cl_device_id devList[] = { deviceId, NULL };
		std::vector< cl_semaphore_properties_khr> sema_props{
		 (cl_semaphore_properties_khr)CL_SEMAPHORE_TYPE_KHR,
		 (cl_semaphore_properties_khr)CL_SEMAPHORE_TYPE_BINARY,
		};

        sema_props.push_back((cl_semaphore_properties_khr)CL_DEVICE_HANDLE_LIST_KHR);
        sema_props.push_back((cl_semaphore_properties_khr)devList[0]);
        sema_props.push_back((cl_semaphore_properties_khr)CL_DEVICE_HANDLE_LIST_END_KHR);
#ifdef _WIN32
		if (!isExtensionAvailable(devList[0], "cl_khr_external_semaphore_win32")) {
			throw std::runtime_error(" Device does not support cl_khr_external_semaphore_win32 extension \n");
		}
		err = check_external_semaphore_handle_type(devList[0], IsWindows8OrGreater() ? CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KHR
			: CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KMT_KHR);
		sema_props.push_back((cl_semaphore_properties_khr)(IsWindows8OrGreater() ? CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KHR
			: CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KMT_KHR));
		handle = getVkSemaphoreHandle(
			IsWindows8OrGreater()
			? VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
			clUpdateVkSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)handle);
#else
		if (!isExtensionAvailable(devList[0], "cl_khr_external_semaphore_opaque_fd")) {
			throw std::runtime_error(" Device does not support cl_khr_external_semaphore_opaque_fd extension \n");
		}
		err = check_external_semaphore_handle_type(devList[0], CL_SEMAPHORE_HANDLE_OPAQUE_FD_KHR);
		sema_props.push_back((cl_semaphore_properties_khr)CL_SEMAPHORE_HANDLE_OPAQUE_FD_KHR);
		int fd = getVkSemaphoreHandle(
			VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT, clUpdateVkSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)fd);
#endif
		if (CL_SUCCESS != err) {
			throw std::runtime_error("Unsupported external sempahore handle type\n ");
		}
		sema_props.push_back(0);
		clOpenCLUpdateVkVertexBufSemaphore = clCreateSemaphoreWithPropertiesKHRptr(context, sema_props.data(), &err);
		if (0 != checkResult(err, "clCreateSemaphoreWithPropertiesKHR")) {
			throw std::runtime_error("clCreateSemaphoreWithPropertiesKHR failed!");
		}
		sema_props.pop_back();
		sema_props.pop_back();
#ifdef _WIN32
		handle = getVkSemaphoreHandle(
			IsWindows8OrGreater() ? VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
			vkUpdateclSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)handle);
#else
		fd = getVkSemaphoreHandle(VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT, vkUpdateclSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)fd);

#endif
		sema_props.push_back(0);
		clVkUpdateOpenCLVertexBufSemaphore = clCreateSemaphoreWithPropertiesKHRptr(context, sema_props.data(), &err);
		if (0 != checkResult(err, "clCreateSemaphoreWithPropertiesKHR")) {
			throw std::runtime_error("clCreateSemaphoreWithPropertiesKHR failed!");
		}
		printf("OpenCL Imported Vulkan semaphore\n");
	}

	cl_int getCLFormatFromVkFormat(VkFormat vkFormat, cl_image_format* clImageFormat) {
		cl_int result = CL_SUCCESS;
		switch (vkFormat) {
		case VK_FORMAT_R8G8B8A8_UNORM:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNORM_INT8;
			break;
		case VK_FORMAT_B8G8R8A8_UNORM:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_UNORM_INT8;
			break;
		case VK_FORMAT_R16G16B16A16_UNORM:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNORM_INT16;
			break;
		case VK_FORMAT_R8G8B8A8_SINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT8;
			break;
		case VK_FORMAT_R16G16B16A16_SINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT16;
			break;
		case VK_FORMAT_R32G32B32A32_SINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT32;
			break;
		case VK_FORMAT_R8G8B8A8_UINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT8;
			break;
		case VK_FORMAT_R16G16B16A16_UINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT16;
			break;
		case VK_FORMAT_R32G32B32A32_UINT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT32;
			break;
		case VK_FORMAT_R16G16B16A16_SFLOAT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_HALF_FLOAT;
			break;
		case VK_FORMAT_R32G32B32A32_SFLOAT:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_FLOAT;
			break;
		case VK_FORMAT_R8_SNORM:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_SNORM_INT8;
			break;
		case VK_FORMAT_R16_SNORM:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_SNORM_INT16;
			break;
		case VK_FORMAT_R8_UNORM:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_UNORM_INT8;
			break;
		case VK_FORMAT_R16_UNORM:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_UNORM_INT16;
			break;
		case VK_FORMAT_R8_SINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT8;
			break;
		case VK_FORMAT_R16_SINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT16;
			break;
		case VK_FORMAT_R32_SINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT32;
			break;
		case VK_FORMAT_R8_UINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT8;
			break;
		case VK_FORMAT_R16_UINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT16;
			break;
		case VK_FORMAT_R32_UINT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT32;
			break;
		case VK_FORMAT_R16_SFLOAT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_HALF_FLOAT;
			break;
		case VK_FORMAT_R32_SFLOAT:
			clImageFormat->image_channel_order = CL_R;
			clImageFormat->image_channel_data_type = CL_FLOAT;
			break;
		case VK_FORMAT_R8G8_SNORM:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_SNORM_INT8;
			break;
		case VK_FORMAT_R16G16_SNORM:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_SNORM_INT16;
			break;
		case VK_FORMAT_R8G8_UNORM:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_UNORM_INT8;
			break;
		case VK_FORMAT_R16G16_UNORM:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_UNORM_INT16;
			break;
		case VK_FORMAT_R8G8_SINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT8;
			break;
		case VK_FORMAT_R16G16_SINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT16;
			break;
		case VK_FORMAT_R32G32_SINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT32;
			break;
		case VK_FORMAT_R8G8_UINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT8;
			break;
		case VK_FORMAT_R16G16_UINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT16;
			break;
		case VK_FORMAT_R32G32_UINT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT32;
			break;
		case VK_FORMAT_R16G16_SFLOAT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_HALF_FLOAT;
			break;
		case VK_FORMAT_R32G32_SFLOAT:
			clImageFormat->image_channel_order = CL_RG;
			clImageFormat->image_channel_data_type = CL_FLOAT;
			break;
		case VK_FORMAT_R5G6B5_UNORM_PACK16:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNORM_SHORT_565;
			break;
		case VK_FORMAT_R5G5B5A1_UNORM_PACK16:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_UNORM_SHORT_555;
			break;
		case VK_FORMAT_R8G8B8A8_SNORM:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_SNORM_INT8;
			break;
		case VK_FORMAT_R16G16B16A16_SNORM:
			clImageFormat->image_channel_order = CL_RGBA;
			clImageFormat->image_channel_data_type = CL_SNORM_INT16;
			break;
		case VK_FORMAT_B8G8R8A8_SNORM:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_SNORM_INT8;
			break;
		case VK_FORMAT_B5G6R5_UNORM_PACK16:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_UNORM_SHORT_565;
			break;
		case VK_FORMAT_B5G5R5A1_UNORM_PACK16:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_UNORM_SHORT_555;
			break;
		case VK_FORMAT_B8G8R8A8_SINT:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_SIGNED_INT8;
			break;
		case VK_FORMAT_B8G8R8A8_UINT:
			clImageFormat->image_channel_order = CL_BGRA;
			clImageFormat->image_channel_data_type = CL_UNSIGNED_INT8;
			break;
		case VK_FORMAT_A8B8G8R8_SNORM_PACK32:
			result = CL_INVALID_VALUE;
			break;
		case VK_FORMAT_A8B8G8R8_UNORM_PACK32:
			result = CL_INVALID_VALUE;
			break;
		case VK_FORMAT_A8B8G8R8_SINT_PACK32:
			result = CL_INVALID_VALUE;
			break;
		case VK_FORMAT_A8B8G8R8_UINT_PACK32:
			result = CL_INVALID_VALUE;
			break;
		default:
			std::cout << " Unsupported format";
			break;
		}
		return result;
	}

	cl_mem_object_type getImageTypeFromVk(VkImageType imageType)
	{
		cl_mem_object_type cl_image_type = CL_INVALID_VALUE;
		switch (imageType) {
		case VK_IMAGE_TYPE_1D:
			cl_image_type = CL_MEM_OBJECT_IMAGE1D;
			break;
		case VK_IMAGE_TYPE_2D:
			cl_image_type = CL_MEM_OBJECT_IMAGE2D;
			break;
		case VK_IMAGE_TYPE_3D:
			cl_image_type = CL_MEM_OBJECT_IMAGE3D;
			break;
		default:
			break;
		}
		return cl_image_type;
	}

	cl_int getCLImageInfoFromVkImageInfo(VkImageCreateInfo* VulkanImageCreateInfo, cl_image_format* img_fmt, cl_image_desc* img_desc)
	{
		cl_int result = CL_SUCCESS;

		cl_image_format clImgFormat = { 0 };
		result = getCLFormatFromVkFormat(VulkanImageCreateInfo->format, &clImgFormat);
		if (CL_SUCCESS != result) {
			return result;
		}
		memcpy(img_fmt, &clImgFormat, sizeof(cl_image_format));

		img_desc->image_type = getImageTypeFromVk(VulkanImageCreateInfo->imageType);
		if (CL_INVALID_VALUE == img_desc->image_type) {
			return CL_INVALID_VALUE;
		}
		img_desc->image_width = VulkanImageCreateInfo->extent.width;
		img_desc->image_height = VulkanImageCreateInfo->extent.height;
		img_desc->image_depth = 0;
		img_desc->image_array_size = 0;
		img_desc->image_row_pitch = 0; // Row pitch set to zero as host_ptr is NULL 
		img_desc->image_slice_pitch = img_desc->image_row_pitch * img_desc->image_height;
		img_desc->num_mip_levels = 1;
		img_desc->num_samples = 0;
		img_desc->buffer = NULL;

		return result;
	}
	void openCLVkImportImageMem() {
		int errcode_ret;
		void* handle = NULL;
		cl_device_id devList[] = { deviceId, NULL };

		std::vector< cl_mem_properties> extMemProperties1;

#ifdef _WIN32
		if (!isExtensionAvailable(devList[0], "cl_khr_external_memory_win32")) {
			throw std::runtime_error(" Device does not support cl_khr_external_memory_win32 extension \n");
		}
		errcode_ret = check_external_memory_handle_type(devList[0], (IsWindows8OrGreater() ? CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KHR
			: CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KMT_KHR));
		handle = getVkImageMemHandle(
			IsWindows8OrGreater()
			? VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT);
		extMemProperties1.push_back((cl_mem_properties_khr)(IsWindows8OrGreater() ? CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KHR
			: CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KMT_KHR));
		extMemProperties1.push_back((cl_mem_properties_khr)handle);
#else
		if (!isExtensionAvailable(devList[0], "cl_khr_external_memory_opaque_fd")) {
			throw std::runtime_error(" Device does not support cl_khr_external_memory_opaque_fd extension \n");
		}
		errcode_ret = check_external_memory_handle_type(devList[0], CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_FD_KHR);
		int fd1 = getVkImageMemHandle(VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR);
		extMemProperties1.push_back((cl_mem_properties_khr)CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_FD_KHR);
		extMemProperties1.push_back((cl_mem_properties_khr)fd1);
#endif
		if (CL_SUCCESS != errcode_ret) {
			throw std::runtime_error("Unsupported external memory type\n ");
		}
		size_t clImageFormatSize;

		cl_image_desc image_desc1 = { };
		cl_image_format clImageFormat1 = { };

		errcode_ret = getCLImageInfoFromVkImageInfo(&imageInfo1, &clImageFormat1, &image_desc1);
		if (CL_SUCCESS != errcode_ret) {
			throw std::runtime_error("getCLImageInfoFromVkImageInfo failed!!!");
		}

        extMemProperties1.push_back((cl_mem_properties_khr)CL_DEVICE_HANDLE_LIST_KHR);
        extMemProperties1.push_back((cl_mem_properties_khr)devList[0]);
        extMemProperties1.push_back((cl_mem_properties_khr)CL_DEVICE_HANDLE_LIST_END_KHR);

		extMemProperties1.push_back(0);

		img1 = clCreateImageWithProperties(context,
			extMemProperties1.data(),
			CL_MEM_READ_WRITE,
			&clImageFormat1,
			&image_desc1,
			NULL,
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error " << errcode_ret << std::endl;
			throw std::runtime_error("clCreateImageWithProperties failed");
		}
		std::cout << "clCreateImageWithProperties passed with extMemProperties\n";

		img2 = clCreateImageWithProperties(context,
			NULL,
			CL_MEM_READ_WRITE,
			&clImageFormat1,
			&image_desc1,
			NULL,
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error " << errcode_ret << std::endl;
			throw std::runtime_error("clCreateImageWithProperties failed");
		}
		std::cout << "clCreateImageWithProperties passed with NULL extMemProperties\n";
		img3 = clCreateImageWithProperties(context,
			NULL,
			CL_MEM_READ_WRITE,
			&clImageFormat1,
			&image_desc1,
			NULL,
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error " << errcode_ret << std::endl;
			throw std::runtime_error("clCreateImageWithProperties failed");
		}

		// Check different failure combinations of cl_mem_properties and image info.

		// Both image format, desc and properties null.
		cl_mem img_test;
		img_test = clCreateImageWithProperties(context,
			NULL,  // properties passed as NULL
			CL_MEM_READ_WRITE,
			NULL, // image format passed as NULL
			NULL, // image desc passed as NULL
			NULL, // void ptr passed as NULL
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error for both image format, desc and properties NULL = " << errcode_ret << std::endl;
		}

		// Mismatch image format
		cl_image_format clImageFormat3 = { };
		clImageFormat3.image_channel_order = CL_RGB;
		clImageFormat3.image_channel_data_type = CL_UNORM_INT8;

		img_test = clCreateImageWithProperties(context,
			extMemProperties1.data(),
			CL_MEM_READ_WRITE,
			&clImageFormat3, //mismatch image format
			&image_desc1,
			NULL,
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error for mismatch image format =" << errcode_ret << std::endl;
		}

		// Mismatch image Desc
		cl_image_desc image_desc3 = { };
		image_desc3.image_type = CL_MEM_OBJECT_IMAGE3D;
		image_desc3.image_width = imageWidth;
		image_desc3.image_height = imageHeight;
		image_desc3.image_depth = 0;
		image_desc3.image_array_size = 0;// allocInfo.allocationSize;
		image_desc3.image_row_pitch = 0;
		image_desc3.image_slice_pitch = image_desc3.image_row_pitch * imageHeight;
		image_desc3.num_mip_levels = 1;
		image_desc3.num_samples = 0;
		image_desc3.buffer = NULL;

		img_test = clCreateImageWithProperties(context,
			extMemProperties1.data(),
			CL_MEM_READ_WRITE,
			&clImageFormat1,
			&image_desc3, // mismatch image desc
			NULL,
			&errcode_ret);
		if (CL_SUCCESS != errcode_ret) {
			std::cout << "clCreateImageWithProperties return error for mismatch image desc = " << errcode_ret << std::endl;
		}

		if (NULL != img1) {
			cl_int result;

			result = clGetImageInfo(img1,
				CL_IMAGE_FORMAT,
				sizeof(cl_image_format),
				&clImageFormat1,
				&clImageFormatSize);
			if (CL_SUCCESS == result) {
				if (clImageFormat1.image_channel_order == clImageFormat1.image_channel_order &&
					clImageFormat1.image_channel_data_type == clImageFormat1.image_channel_data_type) {
					printf("clGetImageInfo for CL_IMAGE_FORMAT returned correct channel order and channel data type\n");
				}
			}
		}

		printf("OpenCL Kernel Vulkan image buffer\n");
	}

	cl_int clUpdateVkImage() {

		cl_int err;

		err = clSetKernelArg(kernel_1, 0, sizeof(cl_mem), &img2);
		err |= clSetKernelArg(kernel_1, 1, sizeof(cl_mem), &img1);
		err |= clSetKernelArg(kernel_1, 2, sizeof(unsigned int), &imageWidth);
		err |= clSetKernelArg(kernel_1, 3, sizeof(unsigned int), &imageHeight);
		err |= clSetKernelArg(kernel_1, 4, sizeof(unsigned int), &mipLevels);
		err |= clSetKernelArg(kernel_1, 5, sizeof(unsigned int), &filter_radius);

		if (err != CL_SUCCESS) {
			printf("Error: Failed to set arg values for kernel-1,err=%d\n", err);
			return err;
		}

		err = clSetKernelArg(kernel_2, 0, sizeof(cl_mem), &img1);
		err |= clSetKernelArg(kernel_2, 1, sizeof(cl_mem), &img2);
		err |= clSetKernelArg(kernel_2, 2, sizeof(unsigned int), &imageWidth);
		err |= clSetKernelArg(kernel_2, 3, sizeof(unsigned int), &imageHeight);
		err |= clSetKernelArg(kernel_2, 4, sizeof(unsigned int), &mipLevels);
		err |= clSetKernelArg(kernel_2, 5, sizeof(unsigned int), &filter_radius);

		if (err != CL_SUCCESS) {
			printf("Error: Failed to set arg values for kernel-2\n");
			return err;
		}
		if (flag == 0) {
			err = clSetKernelArg(kernel_3, 0, sizeof(cl_mem), &img3);
			err |= clSetKernelArg(kernel_3, 1, sizeof(cl_mem), &img1);
			if (err != CL_SUCCESS) {
				printf("Error: Failed to set arg values for kernel-3\n");
				return err;
			}
			flag = 1;
		}
		else {
			err = clSetKernelArg(kernel_3, 0, sizeof(cl_mem), &img1);
			err |= clSetKernelArg(kernel_3, 1, sizeof(cl_mem), &img3);
			if (err != CL_SUCCESS) {
				printf("Error: Failed to set arg values for kernel-3\n");
				return err;
			}
		}
		err = clEnqueueWaitSemaphoresKHRptr(cmd_queue, 1, &clVkUpdateOpenCLVertexBufSemaphore, NULL, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueWaitForSemaphoresKHR")) {
			throw std::runtime_error("Failed clEnqueueWaitForSemaphoresKHR!");
		}

		err = clEnqueueAcquireExternalMemObjectsKHRptr(cmd_queue, 1, &img1, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueAcquireExternalMemObjectsKHR")) {
			throw std::runtime_error("Failed clEnqueueAcquireExternalMemObjectsKHR!");
		}

		size_t local_work_size[2] = { 64, 1 };
		size_t global_work_size[2] = { imageWidth, imageHeight };

		err = clEnqueueNDRangeKernel(cmd_queue, kernel_3, 2, NULL,
			global_work_size, local_work_size, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueNDRangeKernel")) {
			throw std::runtime_error("Failed clEnqueueNDRangeKernel for kernel-3!");
		}
		printf("Kernel-3 launch success and contents copied back to image1\n");

		global_work_size[0] = imageHeight;
		global_work_size[1] = 1;
		err = clEnqueueNDRangeKernel(cmd_queue, kernel_1, 2, NULL,
			global_work_size, local_work_size, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueNDRangeKernel")) {
			throw std::runtime_error("Failed clEnqueueNDRangeKernel for kernel-2!");
		}
		printf("Kernel-1 launch success \n");

		global_work_size[0] = imageWidth;
		err = clEnqueueNDRangeKernel(cmd_queue, kernel_2, 2, NULL,
			global_work_size, local_work_size, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueNDRangeKernel")) {
			throw std::runtime_error("Failed clEnqueueNDRangeKernel for kernel-1!");

		}
		printf("Kernel-2 launch success\n");

		clFinish(cmd_queue);
		varySigma();

		err = clEnqueueReleaseExternalMemObjectsKHRptr(cmd_queue, 1, &img1, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueReleaseExternalMemObjectsKHR")) {
			throw std::runtime_error("Failed clEnqueueReleaseExternalMemObjectsKHR!");
		}
		err = clEnqueueSignalSemaphoresKHRptr(cmd_queue, 1, &clOpenCLUpdateVkVertexBufSemaphore, NULL, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueSignalSemaphoresKHR")) {
			throw std::runtime_error("Failed clEnqueueSignalSemaphoresKHRptr!");
		}
		printf("Image update done!!!\n");
	}

	void transitionImageLayout(VkImage image, VkFormat format,
		VkImageLayout oldLayout, VkImageLayout newLayout) {
		VkCommandBuffer commandBuffer = beginSingleTimeCommands();

		VkImageMemoryBarrier barrier = {};
		barrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
		barrier.oldLayout = oldLayout;
		barrier.newLayout = newLayout;
		barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.image = image;
		barrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		barrier.subresourceRange.baseMipLevel = 0;
		barrier.subresourceRange.levelCount = mipLevels;
		barrier.subresourceRange.baseArrayLayer = 0;
		barrier.subresourceRange.layerCount = 1;

		VkPipelineStageFlags sourceStage;
		VkPipelineStageFlags destinationStage;

		if (oldLayout == VK_IMAGE_LAYOUT_UNDEFINED &&
			newLayout == VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) {
			barrier.srcAccessMask = 0;
			barrier.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;

			sourceStage = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
			destinationStage = VK_PIPELINE_STAGE_TRANSFER_BIT;
		}
		else if (oldLayout == VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL &&
			newLayout == VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
			barrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
			barrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;

			sourceStage = VK_PIPELINE_STAGE_TRANSFER_BIT;
			destinationStage = VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;
		}
		else {
			throw std::invalid_argument("unsupported layout transition!");
		}

		vkCmdPipelineBarrier(commandBuffer, sourceStage, destinationStage, 0, 0,
			nullptr, 0, nullptr, 1, &barrier);

		endSingleTimeCommands(commandBuffer);
	}

	void copyBufferToImage(VkBuffer buffer, VkImage image, uint32_t width,
		uint32_t height) {
		VkCommandBuffer commandBuffer = beginSingleTimeCommands();

		VkBufferImageCopy region = {};
		region.bufferOffset = 0;
		region.bufferRowLength = 0;
		region.bufferImageHeight = 0;
		region.imageSubresource.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
		region.imageSubresource.mipLevel = 0;
		region.imageSubresource.baseArrayLayer = 0;
		region.imageSubresource.layerCount = 1;
		region.imageOffset = { 0, 0, 0 };
		region.imageExtent = { width, height, 1 };

		vkCmdCopyBufferToImage(commandBuffer, buffer, image,
			VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region);

		endSingleTimeCommands(commandBuffer);
	}

	void createVertexBuffer() {
		VkDeviceSize bufferSize = sizeof(vertices[0]) * vertices.size();

		VkBuffer stagingBuffer;
		VkDeviceMemory stagingBufferMemory;
		createBuffer(bufferSize, VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
			VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
			VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
			stagingBuffer, stagingBufferMemory);

		void* data;
		vkMapMemory(device, stagingBufferMemory, 0, bufferSize, 0, &data);
		memcpy(data, vertices.data(), (size_t)bufferSize);
		vkUnmapMemory(device, stagingBufferMemory);

		createBuffer(
			bufferSize,
			VK_BUFFER_USAGE_TRANSFER_DST_BIT | VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
			0, vertexBuffer, vertexBufferMemory);

		copyBuffer(stagingBuffer, vertexBuffer, bufferSize);

		vkDestroyBuffer(device, stagingBuffer, nullptr);
		vkFreeMemory(device, stagingBufferMemory, nullptr);
	}

	void createIndexBuffer() {
		VkDeviceSize bufferSize = sizeof(indices[0]) * indices.size();

		VkBuffer stagingBuffer;
		VkDeviceMemory stagingBufferMemory;
		createBuffer(bufferSize, VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
			VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
			VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
			stagingBuffer, stagingBufferMemory);

		void* data;
		vkMapMemory(device, stagingBufferMemory, 0, bufferSize, 0, &data);
		memcpy(data, indices.data(), (size_t)bufferSize);
		vkUnmapMemory(device, stagingBufferMemory);

		createBuffer(
			bufferSize,
			VK_BUFFER_USAGE_TRANSFER_DST_BIT | VK_BUFFER_USAGE_INDEX_BUFFER_BIT,
			0, indexBuffer, indexBufferMemory);

		copyBuffer(stagingBuffer, indexBuffer, bufferSize);

		vkDestroyBuffer(device, stagingBuffer, nullptr);
		vkFreeMemory(device, stagingBufferMemory, nullptr);
	}

	void createUniformBuffers() {
		VkDeviceSize bufferSize = sizeof(UniformBufferObject);

		uniformBuffers.resize(swapChainImages.size());
		uniformBuffersMemory.resize(swapChainImages.size());

		for (size_t i = 0; i < swapChainImages.size(); i++) {
			createBuffer(bufferSize, VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
				VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
				VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
				uniformBuffers[i], uniformBuffersMemory[i]);
		}
	}

	void createDescriptorPool() {
		std::array<VkDescriptorPoolSize, 2> poolSizes = {};
		poolSizes[0].type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		poolSizes[0].descriptorCount =
			static_cast<uint32_t>(swapChainImages.size());
		poolSizes[1].type = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		poolSizes[1].descriptorCount =
			static_cast<uint32_t>(swapChainImages.size());

		VkDescriptorPoolCreateInfo poolInfo = {};
		poolInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
		poolInfo.poolSizeCount = static_cast<uint32_t>(poolSizes.size());
		poolInfo.pPoolSizes = poolSizes.data();
		poolInfo.maxSets = static_cast<uint32_t>(swapChainImages.size());

		if (vkCreateDescriptorPool(device, &poolInfo, nullptr, &descriptorPool) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create descriptor pool!");
		}
	}

	void createDescriptorSets() {
		std::vector<VkDescriptorSetLayout> layouts(swapChainImages.size(),
			descriptorSetLayout);
		VkDescriptorSetAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocInfo.descriptorPool = descriptorPool;
		allocInfo.descriptorSetCount =
			static_cast<uint32_t>(swapChainImages.size());
		allocInfo.pSetLayouts = layouts.data();

		descriptorSets.resize(swapChainImages.size());
		if (vkAllocateDescriptorSets(device, &allocInfo, descriptorSets.data()) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate descriptor sets!");
		}

		for (size_t i = 0; i < swapChainImages.size(); i++) {
			VkDescriptorBufferInfo bufferInfo = {};
			bufferInfo.buffer = uniformBuffers[i];
			bufferInfo.offset = 0;
			bufferInfo.range = sizeof(UniformBufferObject);

			VkDescriptorImageInfo imageInfo = {};
			imageInfo.imageLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
			imageInfo.imageView = textureImageView;
			imageInfo.sampler = textureSampler;

			std::array<VkWriteDescriptorSet, 2> descriptorWrites = {};

			descriptorWrites[0].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
			descriptorWrites[0].dstSet = descriptorSets[i];
			descriptorWrites[0].dstBinding = 0;
			descriptorWrites[0].dstArrayElement = 0;
			descriptorWrites[0].descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
			descriptorWrites[0].descriptorCount = 1;
			descriptorWrites[0].pBufferInfo = &bufferInfo;

			descriptorWrites[1].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
			descriptorWrites[1].dstSet = descriptorSets[i];
			descriptorWrites[1].dstBinding = 1;
			descriptorWrites[1].dstArrayElement = 0;
			descriptorWrites[1].descriptorType =
				VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
			descriptorWrites[1].descriptorCount = 1;
			descriptorWrites[1].pImageInfo = &imageInfo;

			vkUpdateDescriptorSets(device,
				static_cast<uint32_t>(descriptorWrites.size()),
				descriptorWrites.data(), 0, nullptr);
		}
	}

	void createBuffer(VkDeviceSize size, VkBufferUsageFlags usage,
		VkMemoryPropertyFlags properties, VkBuffer& buffer,
		VkDeviceMemory& bufferMemory) {
		VkBufferCreateInfo bufferInfo = {};
		bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
		bufferInfo.size = size;
		bufferInfo.usage = usage;
		bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

		if (vkCreateBuffer(device, &bufferInfo, nullptr, &buffer) != VK_SUCCESS) {
			throw std::runtime_error("failed to create buffer!");
		}

		VkMemoryRequirements memRequirements;
		vkGetBufferMemoryRequirements(device, buffer, &memRequirements);

		VkMemoryAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
		allocInfo.allocationSize = memRequirements.size;
		allocInfo.memoryTypeIndex =
			findMemoryType(memRequirements.memoryTypeBits, properties);

		if (vkAllocateMemory(device, &allocInfo, nullptr, &bufferMemory) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate buffer memory!");
		}

		vkBindBufferMemory(device, buffer, bufferMemory, 0);
	}

	VkCommandBuffer beginSingleTimeCommands() {
		VkCommandBufferAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
		allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		allocInfo.commandPool = commandPool;
		allocInfo.commandBufferCount = 1;

		VkCommandBuffer commandBuffer;
		vkAllocateCommandBuffers(device, &allocInfo, &commandBuffer);

		VkCommandBufferBeginInfo beginInfo = {};
		beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
		beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

		vkBeginCommandBuffer(commandBuffer, &beginInfo);

		return commandBuffer;
	}

	void endSingleTimeCommands(VkCommandBuffer commandBuffer) {
		vkEndCommandBuffer(commandBuffer);

		VkSubmitInfo submitInfo = {};
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = &commandBuffer;

		vkQueueSubmit(graphicsQueue, 1, &submitInfo, VK_NULL_HANDLE);
		vkQueueWaitIdle(graphicsQueue);

		vkFreeCommandBuffers(device, commandPool, 1, &commandBuffer);
	}

	void copyBuffer(VkBuffer srcBuffer, VkBuffer dstBuffer, VkDeviceSize size) {
		VkCommandBuffer commandBuffer = beginSingleTimeCommands();

		VkBufferCopy copyRegion = {};
		copyRegion.size = size;
		vkCmdCopyBuffer(commandBuffer, srcBuffer, dstBuffer, 1, &copyRegion);

		endSingleTimeCommands(commandBuffer);
	}

	uint32_t findMemoryType(uint32_t typeFilter,
		VkMemoryPropertyFlags properties) {
		VkPhysicalDeviceMemoryProperties memProperties;
		vkGetPhysicalDeviceMemoryProperties(physicalDevice, &memProperties);

		for (uint32_t i = 0; i < memProperties.memoryTypeCount; i++) {
			if ((typeFilter & (1 << i)) &&
				(memProperties.memoryTypes[i].propertyFlags & properties) ==
				properties) {
				return i;
			}
		}

		throw std::runtime_error("failed to find suitable memory type!");
	}

	void createCommandBuffers() {
		commandBuffers.resize(swapChainFramebuffers.size());

		VkCommandBufferAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
		allocInfo.commandPool = commandPool;
		allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		allocInfo.commandBufferCount = (uint32_t)commandBuffers.size();

		if (vkAllocateCommandBuffers(device, &allocInfo, commandBuffers.data()) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate command buffers!");
		}

		for (size_t i = 0; i < commandBuffers.size(); i++) {
			VkCommandBufferBeginInfo beginInfo = {};
			beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
			beginInfo.flags = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;

			if (vkBeginCommandBuffer(commandBuffers[i], &beginInfo) != VK_SUCCESS) {
				throw std::runtime_error("failed to begin recording command buffer!");
			}

			VkRenderPassBeginInfo renderPassInfo = {};
			renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
			renderPassInfo.renderPass = renderPass;
			renderPassInfo.framebuffer = swapChainFramebuffers[i];
			renderPassInfo.renderArea.offset = { 0, 0 };
			renderPassInfo.renderArea.extent = swapChainExtent;

			VkClearValue clearColor = { 0.0f, 0.0f, 0.0f, 1.0f };
			renderPassInfo.clearValueCount = 1;
			renderPassInfo.pClearValues = &clearColor;

			vkCmdBeginRenderPass(commandBuffers[i], &renderPassInfo,
				VK_SUBPASS_CONTENTS_INLINE);

			vkCmdBindPipeline(commandBuffers[i], VK_PIPELINE_BIND_POINT_GRAPHICS,
				graphicsPipeline);

			VkBuffer vertexBuffers[] = { vertexBuffer };
			VkDeviceSize offsets[] = { 0 };
			vkCmdBindVertexBuffers(commandBuffers[i], 0, 1, vertexBuffers, offsets);

			vkCmdBindIndexBuffer(commandBuffers[i], indexBuffer, 0,
				VK_INDEX_TYPE_UINT16);

			vkCmdBindDescriptorSets(commandBuffers[i],
				VK_PIPELINE_BIND_POINT_GRAPHICS, pipelineLayout,
				0, 1, &descriptorSets[i], 0, nullptr);

			vkCmdDrawIndexed(commandBuffers[i], static_cast<uint32_t>(indices.size()),
				1, 0, 0, 0);
			// vkCmdDraw(commandBuffers[i], static_cast<uint32_t>(vertices.size()), 1,
			// 0, 0);

			vkCmdEndRenderPass(commandBuffers[i]);

			if (vkEndCommandBuffer(commandBuffers[i]) != VK_SUCCESS) {
				throw std::runtime_error("failed to record command buffer!");
			}
		}
	}

	void createSyncObjects() {
		imageAvailableSemaphores.resize(MAX_FRAMES);
		renderFinishedSemaphores.resize(MAX_FRAMES);
		inFlightFences.resize(MAX_FRAMES);

		VkSemaphoreCreateInfo semaphoreInfo = {};
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

		VkFenceCreateInfo fenceInfo = {};
		fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
		fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;

		for (size_t i = 0; i < MAX_FRAMES; i++) {
			if (vkCreateSemaphore(device, &semaphoreInfo, nullptr,
				&imageAvailableSemaphores[i]) != VK_SUCCESS ||
				vkCreateSemaphore(device, &semaphoreInfo, nullptr,
					&renderFinishedSemaphores[i]) != VK_SUCCESS ||
				vkCreateFence(device, &fenceInfo, nullptr, &inFlightFences[i]) !=
				VK_SUCCESS) {
				throw std::runtime_error(
					"failed to create synchronization objects for a frame!");
			}
		}
	}

	void createSyncObjectsExt() {
		VkSemaphoreCreateInfo semaphoreInfo = {};
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

		memset(&semaphoreInfo, 0, sizeof(semaphoreInfo));
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

#ifdef _WIN32
		WindowsSecurityAttributes winSecurityAttributes;

		VkExportSemaphoreWin32HandleInfoKHR
			vulkanExportSemaphoreWin32HandleInfoKHR = {};
		vulkanExportSemaphoreWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
		vulkanExportSemaphoreWin32HandleInfoKHR.pNext = NULL;
		vulkanExportSemaphoreWin32HandleInfoKHR.pAttributes =
			&winSecurityAttributes;
		vulkanExportSemaphoreWin32HandleInfoKHR.dwAccess =
			DXGI_SHARED_RESOURCE_READ | DXGI_SHARED_RESOURCE_WRITE;
		vulkanExportSemaphoreWin32HandleInfoKHR.name = (LPCWSTR)NULL;
#endif
		VkExportSemaphoreCreateInfoKHR vulkanExportSemaphoreCreateInfo = {};
		vulkanExportSemaphoreCreateInfo.sType =
			VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR;
#ifdef _WIN32
		vulkanExportSemaphoreCreateInfo.pNext =
			IsWindows8OrGreater() ? &vulkanExportSemaphoreWin32HandleInfoKHR : NULL;
		vulkanExportSemaphoreCreateInfo.handleTypes =
			IsWindows8OrGreater()
			? VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT;
#else
		vulkanExportSemaphoreCreateInfo.pNext = NULL;
		vulkanExportSemaphoreCreateInfo.handleTypes =
			VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT;
#endif
		semaphoreInfo.pNext = &vulkanExportSemaphoreCreateInfo;

		if (vkCreateSemaphore(device, &semaphoreInfo, nullptr,
			&clUpdateVkSemaphore) != VK_SUCCESS ||
			vkCreateSemaphore(device, &semaphoreInfo, nullptr,
				&vkUpdateclSemaphore) != VK_SUCCESS) {
			throw std::runtime_error(
				"failed to create synchronization objects for a OpenCL-Vulkan!");
		}

	}

	void updateUniformBuffer() {
		UniformBufferObject ubo = {};

		mat4x4_identity(ubo.model);
		mat4x4 Model;
		mat4x4_dup(Model, ubo.model);
		mat4x4_rotate(ubo.model, Model, 0.0f, 0.0f, 1.0f, degreesToRadians(135.0f));

		vec3 eye = { 2.0f, 2.0f, 2.0f };
		vec3 center = { 0.0f, 0.0f, 0.0f };
		vec3 up = { 0.0f, 0.0f, 1.0f };
		mat4x4_look_at(ubo.view, eye, center, up);

		mat4x4_perspective(ubo.proj, degreesToRadians(45.0f),
			swapChainExtent.width / (float)swapChainExtent.height,
			0.1f, 10.0f);
		ubo.proj[1][1] *= -1;

		for (size_t i = 0; i < swapChainImages.size(); i++) {
			void* data;
			vkMapMemory(device, uniformBuffersMemory[i], 0, sizeof(ubo), 0, &data);
			memcpy(data, &ubo, sizeof(ubo));
			vkUnmapMemory(device, uniformBuffersMemory[i]);
		}
	}

	void drawFrame() {
		static int startSubmit = 0;

		vkWaitForFences(device, 1, &inFlightFences[currentFrame], VK_TRUE,
			std::numeric_limits<uint64_t>::max());

		uint32_t imageIndex;
		VkResult result = vkAcquireNextImageKHR(
			device, swapChain, std::numeric_limits<uint64_t>::max(),
			imageAvailableSemaphores[currentFrame], VK_NULL_HANDLE, &imageIndex);

		if (result == VK_ERROR_OUT_OF_DATE_KHR) {
			recreateSwapChain();
			return;
		}
		else if (result != VK_SUCCESS && result != VK_SUBOPTIMAL_KHR) {
			throw std::runtime_error("failed to acquire swap chain image!");
		}

		vkResetFences(device, 1, &inFlightFences[currentFrame]);

		if (!startSubmit) {
			submitVulkan(imageIndex);
			startSubmit = 1;
		}
		else {
			submitVulkancl(imageIndex);
		}

		VkPresentInfoKHR presentInfo = {};
		presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphores[currentFrame] };

		presentInfo.waitSemaphoreCount = 1;
		presentInfo.pWaitSemaphores = signalSemaphores;

		VkSwapchainKHR swapChains[] = { swapChain };
		presentInfo.swapchainCount = 1;
		presentInfo.pSwapchains = swapChains;
		presentInfo.pImageIndices = &imageIndex;
		presentInfo.pResults = nullptr;  // Optional

		result = vkQueuePresentKHR(presentQueue, &presentInfo);

		if (result == VK_ERROR_OUT_OF_DATE_KHR || result == VK_SUBOPTIMAL_KHR ||
			framebufferResized) {
			framebufferResized = false;
			recreateSwapChain();
		}
		else if (result != VK_SUCCESS) {
			throw std::runtime_error("failed to present swap chain image!");
		}

		clUpdateVkImage();

		currentFrame = (currentFrame + 1) % MAX_FRAMES;
		// Added sleep of 10 millisecs so that CPU does not submit too much work to
		// GPU
		std::this_thread::sleep_for(std::chrono::microseconds(10000));
		char title[256];
		sprintf(title, "Vulkan Image OpenCL Box Filter (radius=%d)", filter_radius);
		glfwSetWindowTitle(window, title);
	}

	void submitVulkan(uint32_t imageIndex) {
		VkSubmitInfo submitInfo = {};
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;

		VkSemaphore waitSemaphores[] = { imageAvailableSemaphores[currentFrame] };
		VkPipelineStageFlags waitStages[] = {
			VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT };
		submitInfo.waitSemaphoreCount = 1;
		submitInfo.pWaitSemaphores = waitSemaphores;
		submitInfo.pWaitDstStageMask = waitStages;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = &commandBuffers[imageIndex];

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphores[currentFrame],
										  vkUpdateclSemaphore };

		submitInfo.signalSemaphoreCount = 2;
		submitInfo.pSignalSemaphores = signalSemaphores;

		if (vkQueueSubmit(graphicsQueue, 1, &submitInfo, inFlightFences[currentFrame]) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to submit draw command buffer!");
		}
	}

	void submitVulkancl(uint32_t imageIndex) {
		VkSubmitInfo submitInfo = {};
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;

		VkSemaphore waitSemaphores[] = { imageAvailableSemaphores[currentFrame],
										clUpdateVkSemaphore };
		VkPipelineStageFlags waitStages[] = {
			VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
			VK_PIPELINE_STAGE_ALL_COMMANDS_BIT };
		submitInfo.waitSemaphoreCount = 2;
		submitInfo.pWaitSemaphores = waitSemaphores;
		submitInfo.pWaitDstStageMask = waitStages;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = &commandBuffers[imageIndex];

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphores[currentFrame],
										  vkUpdateclSemaphore };

		submitInfo.signalSemaphoreCount = 2;
		submitInfo.pSignalSemaphores = signalSemaphores;

		if (vkQueueSubmit(graphicsQueue, 1, &submitInfo, inFlightFences[currentFrame]) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to submit draw command buffer!");
		}
	}

	VkShaderModule createShaderModule(const std::vector<char>& code) {
		VkShaderModuleCreateInfo createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
		createInfo.codeSize = code.size();
		createInfo.pCode = reinterpret_cast<const uint32_t*>(code.data());

		VkShaderModule shaderModule;
		if (vkCreateShaderModule(device, &createInfo, nullptr, &shaderModule) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create shader module!");
		}

		return shaderModule;
	}

	VkSurfaceFormatKHR chooseSwapSurfaceFormat(
		const std::vector<VkSurfaceFormatKHR>& availableFormats) {
		if (availableFormats.size() == 1 &&
			availableFormats[0].format == VK_FORMAT_UNDEFINED) {
			return { VK_FORMAT_B8G8R8A8_UNORM, VK_COLOR_SPACE_SRGB_NONLINEAR_KHR };
		}

		for (const auto& availableFormat : availableFormats) {
			if (availableFormat.format == VK_FORMAT_B8G8R8A8_UNORM &&
				availableFormat.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
				return availableFormat;
			}
		}

		return availableFormats[0];
	}

	VkPresentModeKHR chooseSwapPresentMode(
		const std::vector<VkPresentModeKHR>& availablePresentModes) {
		VkPresentModeKHR bestMode = VK_PRESENT_MODE_FIFO_KHR;

		for (const auto& availablePresentMode : availablePresentModes) {
			if (availablePresentMode == VK_PRESENT_MODE_MAILBOX_KHR) {
				return availablePresentMode;
			}
			else if (availablePresentMode == VK_PRESENT_MODE_IMMEDIATE_KHR) {
				bestMode = availablePresentMode;
			}
		}

		return bestMode;
	}

	VkExtent2D chooseSwapExtent(const VkSurfaceCapabilitiesKHR& capabilities) {
		if (capabilities.currentExtent.width !=
			std::numeric_limits<uint32_t>::max()) {
			return capabilities.currentExtent;
		}
		else {
			int width, height;
			glfwGetFramebufferSize(window, &width, &height);

			VkExtent2D actualExtent = { static_cast<uint32_t>(width),
									   static_cast<uint32_t>(height) };

			actualExtent.width = std::max(
				capabilities.minImageExtent.width,
				std::min(capabilities.maxImageExtent.width, actualExtent.width));
			actualExtent.height = std::max(
				capabilities.minImageExtent.height,
				std::min(capabilities.maxImageExtent.height, actualExtent.height));

			return actualExtent;
		}
	}

	SwapChainSupportDetails querySwapChainSupport(VkPhysicalDevice device) {
		SwapChainSupportDetails details;

		vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface,
			&details.capabilities);

		uint32_t formatCount;
		vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &formatCount,
			nullptr);

		if (formatCount != 0) {
			details.formats.resize(formatCount);
			vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &formatCount,
				details.formats.data());
		}

		uint32_t presentModeCount;
		vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface,
			&presentModeCount, nullptr);

		if (presentModeCount != 0) {
			details.presentModes.resize(presentModeCount);
			vkGetPhysicalDeviceSurfacePresentModesKHR(
				device, surface, &presentModeCount, details.presentModes.data());
		}

		return details;
	}

	bool isDeviceSuitable(VkPhysicalDevice device) {
		QueueFamilyIndices indices = findQueueFamilies(device);

		bool extensionsSupported = checkDeviceExtensionSupport(device);

		bool swapChainAdequate = false;
		if (extensionsSupported) {
			SwapChainSupportDetails swapChainSupport = querySwapChainSupport(device);
			swapChainAdequate = !swapChainSupport.formats.empty() &&
				!swapChainSupport.presentModes.empty();
		}

		VkPhysicalDeviceFeatures supportedFeatures;
		vkGetPhysicalDeviceFeatures(device, &supportedFeatures);

		return indices.isComplete() && extensionsSupported && swapChainAdequate &&
			supportedFeatures.samplerAnisotropy;
	}

	bool checkDeviceExtensionSupport(VkPhysicalDevice device) {
		uint32_t extensionCount;
		vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionCount,
			nullptr);

		std::vector<VkExtensionProperties> availableExtensions(extensionCount);
		vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionCount,
			availableExtensions.data());

		std::set<std::string> requiredExtensions(deviceExtensions.begin(),
			deviceExtensions.end());

		for (const auto& extension : availableExtensions) {
			requiredExtensions.erase(extension.extensionName);
		}

		return requiredExtensions.empty();
	}

	QueueFamilyIndices findQueueFamilies(VkPhysicalDevice device) {
		QueueFamilyIndices indices;

		uint32_t queueFamilyCount = 0;
		vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount,
			nullptr);

		std::vector<VkQueueFamilyProperties> queueFamilies(queueFamilyCount);
		vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount,
			queueFamilies.data());

		int i = 0;
		for (const auto& queueFamily : queueFamilies) {
			if (queueFamily.queueCount > 0 &&
				queueFamily.queueFlags & VK_QUEUE_GRAPHICS_BIT) {
				indices.graphicsFamily = i;
			}

			VkBool32 presentSupport = false;
			vkGetPhysicalDeviceSurfaceSupportKHR(device, i, surface, &presentSupport);

			if (queueFamily.queueCount > 0 && presentSupport) {
				indices.presentFamily = i;
			}

			if (indices.isComplete()) {
				break;
			}

			i++;
		}

		return indices;
	}

	std::vector<const char*> getRequiredExtensions() {
		uint32_t glfwExtensionCount = 0;
		const char** glfwExtensions;
		glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

		std::vector<const char*> extensions(glfwExtensions,
			glfwExtensions + glfwExtensionCount);

		if (enableValidationLayers) {
			extensions.push_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
		}

		return extensions;
	}

	bool checkValidationLayerSupport() {
		uint32_t layerCount;
		vkEnumerateInstanceLayerProperties(&layerCount, nullptr);

		std::vector<VkLayerProperties> availableLayers(layerCount);
		vkEnumerateInstanceLayerProperties(&layerCount, availableLayers.data());

		for (const char* layerName : validationLayers) {
			bool layerFound = false;

			for (const auto& layerProperties : availableLayers) {
				if (strcmp(layerName, layerProperties.layerName) == 0) {
					layerFound = true;
					break;
				}
			}

			if (!layerFound) {
				return false;
			}
		}

		return true;
	}

	static std::vector<char> readFile(const std::string& filename) {
		char* file_path = sdkFindFilePath(filename.c_str(), execution_path.c_str());
		std::ifstream file(file_path, std::ios::ate | std::ios::binary);

		if (!file.is_open()) {
			throw std::runtime_error("failed to open file!");
		}

		size_t fileSize = (size_t)file.tellg();
		std::vector<char> buffer(fileSize);

		file.seekg(0);
		file.read(buffer.data(), fileSize);

		file.close();

		return buffer;
	}

	static VKAPI_ATTR VkBool32 VKAPI_CALL
		debugCallback(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
			VkDebugUtilsMessageTypeFlagsEXT messageType,
			const VkDebugUtilsMessengerCallbackDataEXT* pCallbackData,
			void* pUserData) {
		std::cerr << "validation layer: " << pCallbackData->pMessage << std::endl;

		return VK_FALSE;
	}
};

int main(int argc, char** argv) {
	execution_path = argv[0];
	std::string image_filename = "lenaRGB.ppm";

	if (checkCmdLineFlag(argc, (const char**)argv, "file")) {
		getCmdLineArgumentString(argc, (const char**)argv, "file",
			(char**)&image_filename);
	}

	vulkanImageOpenCL app;

	try {
		// This app only works on ppm images
		for (int i = 1;i < argc;i++)
		{
			if (strcmp(argv[i], "-n") == 0)
			{
				if (i + 1 < argc && isdigit(atoi(argv[i + 1])))
					maxFrames = atoi(argv[i++]);
				else
					throw std::runtime_error("Enter integer as -n argument");
			}
		}
		maxFrames = maxFrames <= UINT_MAX ? maxFrames : 1000;
		app.loadImageData(image_filename);
		app.run();
	}
	catch (const std::exception& e) {
		std::cerr << e.what() << std::endl;
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
