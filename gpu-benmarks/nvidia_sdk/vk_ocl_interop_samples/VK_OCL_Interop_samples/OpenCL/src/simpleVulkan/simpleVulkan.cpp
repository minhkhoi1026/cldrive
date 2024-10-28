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
#include <GLFW/glfw3.h>
#include <vulkan/vulkan.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iostream>
#include <set>
#include <stdexcept>
#include <thread>
#include <vector>
#include <stdio.h>
#include <limits.h>

#ifdef _WIN64
#include <aclapi.h>
#include <dxgi1_2.h>
#include <vulkan/vulkan_win32.h>
#include <windows.h>
#include <VersionHelpers.h>
#define _USE_MATH_DEFINES
#endif

//OpenCL
#include <oclUtils.h>
#include <CL/cl.h>
#include <CL/cl_ext.h>
#include <assert.h>


#include "helper_string.h"
#include "linmath.h"

#define WIDTH 800
#define HEIGHT 600
#define BUFFERSIZE 3000

#define VULKAN_VALIDATION 0

const std::vector<const char*> validationLayers = {
	"VK_LAYER_LUNARG_standard_validation" };

#if VULKAN_VALIDATION
const bool enableValidationLayers = true;
#else
const bool enableValidationLayers = false;
#endif

struct QueueFamilyIndices {
	int graphicsFamily = -1;
	int presentFamily = -1;

	bool isComplete() { return graphicsFamily >= 0 && presentFamily >= 0; }
};

const std::vector<const char*> deviceExtensions = {
	VK_KHR_SWAPCHAIN_EXTENSION_NAME,
	VK_KHR_EXTERNAL_MEMORY_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_EXTENSION_NAME,
#ifdef _WIN64
	VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME,
#else
	VK_KHR_EXTERNAL_MEMORY_FD_EXTENSION_NAME,
	VK_KHR_EXTERNAL_SEMAPHORE_FD_EXTENSION_NAME,
#endif
};

#ifdef _WIN64
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
	// CHECK_NEQ(m_winPSecurityDescriptor, (PSECURITY_DESCRIPTOR)NULL);

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

struct UniformBufferObject {
	mat4x4 model;
	mat4x4 view;
	mat4x4 proj;
};

struct SwapChainSupportDetails {
	VkSurfaceCapabilitiesKHR capabilities;
	std::vector<VkSurfaceFormatKHR> formats;
	std::vector<VkPresentModeKHR> presentModes;
};

struct Vertex {
	float pos[4];
	float color[3];

	static VkVertexInputBindingDescription getBindingDescription() {
		VkVertexInputBindingDescription bindingDescription = {};

		bindingDescription.binding = 0;
		bindingDescription.stride = sizeof(Vertex);
		bindingDescription.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;

		return bindingDescription;
	}

	static std::array<VkVertexInputAttributeDescription, 2>
		getAttributeDescriptions() {
		std::array<VkVertexInputAttributeDescription, 2> attributeDescriptions = {};
		attributeDescriptions[0].binding = 0;
		attributeDescriptions[0].location = 0;
		attributeDescriptions[0].format = VK_FORMAT_R32G32B32A32_SFLOAT;
		attributeDescriptions[0].offset = offsetof(Vertex, pos);

		attributeDescriptions[1].binding = 0;
		attributeDescriptions[1].location = 1;
		attributeDescriptions[1].format = VK_FORMAT_R32G32B32_SFLOAT;
		attributeDescriptions[1].offset = offsetof(Vertex, color);
		return attributeDescriptions;
	}
};
unsigned int maxFrames = 1000;
const char* program_source_const;
size_t program_source_length;
unsigned int mesh_width = 0, mesh_height = 0;
std::string execution_path;
cl_uchar uuid[CL_UUID_SIZE_KHR];
int8_t vk_uuid[VK_UUID_SIZE];
cl_platform_id opencl_platform = NULL;
cl_kernel kernel;
cl_program program;
cl_device_id deviceId;

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

const char* kernel_text[] = {
"struct Vertex {                                                   \n"
"\n"
"float pos[4];\n"
"float color[3];\n"
"\n"
"};                                                                           \n"
"__kernel void sinewave_gen_kernel(\n"
"           __global struct Vertex* vertices,\n"
"			unsigned int width,\n"
"			unsigned int height,\n"
"			double time) 										\n"
"			{													\n"
"   unsigned int x = get_global_id(0);	\n"
"   unsigned int y = get_global_id(1);		\n"
"	float u = x / (float)width;									\n"
"	float v = y / (float)height;							    \n"
"	u = u * 2.0f - 1.0f;										\n"
"	v = v * 2.0f - 1.0f;										\n"
"	float freq = 4.0f;											\n"
"	float w = sin(u * freq + time) * cos(v * freq + time) * 0.5f; \n"
"	if (y < height && x < width) { \n"
"\n"
"vertices[y * width + x].pos[0] = u;					\n"
"vertices[y * width + x].pos[1] = w;					\n"
"vertices[y * width + x].pos[2] = v;					\n"
"vertices[y * width + x].pos[3] = 1.0f;				\n"
"vertices[y * width + x].color[0] = 1.0f;			\n"
"vertices[y * width + x].color[1] = 0.0f;			\n"
"vertices[y * width + x].color[2] = 0.0f;			\n"
"}\n"
"}                                                              \n"
};

/*const char *kernel_text[] = {
"struct Vertex {                                                   \n"
"\n"
"float4 pos;\n"
"float3 color;\n"
"\n"
"};                                                                           \n"
"__kernel void sinewave_gen_kernel(\n"
"			__private const struct Vertex* vertices,\n"
"			unsigned int width,\n"
"			unsigned int height,\n"
"			float time) 										\n"
"			{													\n"
"  unsigned int x = get_group_id(0) * get_local_size(0) + get_local_id(0);		\n"
"   unsigned int y = get_group_id(1) * get_local_size(1) + get_local_id(1);		\n"
"	float u = x / (float)width;									\n"
"	float v = y / (float)height;							    \n"
"	u = u * 2.0f - 1.0f;										\n"
"	v = v * 2.0f - 1.0f;										\n"
"	float freq = 4.0f;											\n"
"	float w = sinf(u * freq + time) * cosf(v * freq + time) * 0.5f; \n"
"	if (y < height && x < width) { \n"
"							\n"
"vertices[y * width + x].pos[0] = u;					\n"
"vertices[y * width + x].pos[1] = w;					\n"
"vertices[y * width + x].pos[2] = v;					\n"
"vertices[y * width + x].pos[3] = 1.0f;				\n"
"vertices[y * width + x].color[0] = 1.0f;			\n"
"vertices[y * width + x].color[1] = 0.0f;			\n"
"vertices[y * width + x].color[2] = 0.0f;			\n"
"}															\n"
"}                                                              \n"
};*/
#define checkResult(result, msg)                                                                            \
    ((result != CL_SUCCESS) ?                                                                               \
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


class vulkanOpenCLApp {
public:
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
	VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
	uint8_t vkDeviceUUID[VK_UUID_SIZE];
	VkDevice device;
	VkQueue graphicsQueue;
	VkQueue presentQueue;
	VkSurfaceKHR surface;
	VkSwapchainKHR swapChain;
	std::vector<VkImage> swapChainImages;
	VkFormat swapChainImageFormat;
	VkExtent2D swapChainExtent;
	std::vector<VkImageView> swapChainImageViews;
	VkDescriptorSetLayout descriptorSetLayout;
	VkDescriptorPool descriptorPool;
	VkDescriptorSet descriptorSet;
	VkPipelineLayout pipelineLayout;
	VkRenderPass renderPass;
	VkPipeline graphicsPipeline;
	std::vector<VkFramebuffer> swapChainFramebuffers;
	VkCommandPool commandPool;
	VkBuffer vertexBuffer;
	VkDeviceMemory vertexBufferMemory;
	VkBuffer uniformBuffer;
	VkDeviceMemory uniformBufferMemory;
	std::vector<VkCommandBuffer> commandBuffers;
	VkSemaphore imageAvailableSemaphore;
	VkSemaphore renderFinishedSemaphore;
	VkSemaphore clUpdateVkVertexBufSemaphore;
	VkSemaphore vkUpdateClVertexBufSemaphore;

	size_t vertexBufSize = 0;
	bool startSubmit = 0;
	cl_double AnimTime = 1.0f;

	VkDebugReportCallbackEXT callback;

#ifdef _WIN64
	PFN_vkGetMemoryWin32HandleKHR fpGetMemoryWin32HandleKHR;
	PFN_vkGetSemaphoreWin32HandleKHR fpGetSemaphoreWin32HandleKHR;
#else
	PFN_vkGetMemoryFdKHR fpGetMemoryFdKHR;
	PFN_vkGetSemaphoreFdKHR fpGetSemaphoreFdKHR;
#endif

	PFN_vkGetPhysicalDeviceProperties2 fpGetPhysicalDeviceProperties2;

	//OpenCL stuff
	cl_mem clExternalmemVertexBuffer = NULL;
	cl_context context = NULL;
	cl_command_queue cmd_queue = NULL;
	cl_semaphore_khr clOpenCLUpdateVkVertexBufSemaphore;
	cl_semaphore_khr clVkUpdateOpenCLVertexBufSemaphore;

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

	static VKAPI_ATTR VkBool32 VKAPI_CALL
		debugCallback(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objType,
			uint64_t obj, size_t location, int32_t code,
			const char* layerPrefix, const char* msg, void* userData) {
		std::cerr << "validation layer: " << msg << std::endl;

		return VK_FALSE;
	}

	VkResult CreateDebugReportCallbackEXT(
		VkInstance instance,
		const VkDebugReportCallbackCreateInfoEXT* pCreateInfo,
		const VkAllocationCallbacks* pAllocator,
		VkDebugReportCallbackEXT* pCallback) {
		auto func = (PFN_vkCreateDebugReportCallbackEXT)vkGetInstanceProcAddr(
			instance, "vkCreateDebugReportCallbackEXT");
		if (func != nullptr) {
			return func(instance, pCreateInfo, pAllocator, pCallback);
		}
		else {
			return VK_ERROR_EXTENSION_NOT_PRESENT;
		}
	}

	void DestroyDebugReportCallbackEXT(VkInstance instance,
		VkDebugReportCallbackEXT callback,
		const VkAllocationCallbacks* pAllocator) {
		auto func = (PFN_vkDestroyDebugReportCallbackEXT)vkGetInstanceProcAddr(
			instance, "vkDestroyDebugReportCallbackEXT");
		if (func != nullptr) {
			func(instance, callback, pAllocator);
		}
	}

	void setupDebugCallback() {
		if (!enableValidationLayers) return;

		VkDebugReportCallbackCreateInfoEXT createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
		createInfo.flags =
			VK_DEBUG_REPORT_ERROR_BIT_EXT | VK_DEBUG_REPORT_WARNING_BIT_EXT;
		createInfo.pfnCallback = debugCallback;

		if (CreateDebugReportCallbackEXT(instance, &createInfo, nullptr,
			&callback) != VK_SUCCESS) {
			throw std::runtime_error("failed to set up debug callback!");
		}
	}
	void initWindow() {
		glfwInit();
		glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
		glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
		window = glfwCreateWindow(WIDTH, HEIGHT, "Vulkan-OpenCL Interop Sinewave",
			nullptr, nullptr);
	}

	void createInstance() {
		if (enableValidationLayers && !checkValidationLayerSupport()) {
			throw std::runtime_error(
				"validation layers requested, but not available!");
		}

		VkApplicationInfo appInfo = {};
		appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
		appInfo.pApplicationName = "Vulkan OpenCL Sinewave";
		appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
		appInfo.pEngineName = "No Engine";
		appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
		appInfo.apiVersion = VK_API_VERSION_1_0;

		VkInstanceCreateInfo createInfo = {};
		createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
		createInfo.pApplicationInfo = &appInfo;

		uint32_t glfwExtensionCount = 0;
		const char** glfwExtensions;

		glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

		std::vector<const char*> enabledExtensionNameList;
		enabledExtensionNameList.push_back(
			VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME);
		enabledExtensionNameList.push_back(
			VK_KHR_EXTERNAL_MEMORY_CAPABILITIES_EXTENSION_NAME);
		enabledExtensionNameList.push_back(
			VK_KHR_EXTERNAL_SEMAPHORE_CAPABILITIES_EXTENSION_NAME);

		for (int i = 0; i < glfwExtensionCount; i++) {
			enabledExtensionNameList.push_back(glfwExtensions[i]);
		}
		if (enableValidationLayers) {
			enabledExtensionNameList.push_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
			createInfo.enabledLayerCount =
				static_cast<uint32_t>(validationLayers.size());
			createInfo.ppEnabledLayerNames = validationLayers.data();
		}
		else {
			createInfo.enabledLayerCount = 0;
		}

		createInfo.enabledExtensionCount = enabledExtensionNameList.size();
		createInfo.ppEnabledExtensionNames = enabledExtensionNameList.data();

		if (vkCreateInstance(&createInfo, nullptr, &instance) != VK_SUCCESS) {
			throw std::runtime_error("failed to create instance!");
		}
		else {
			std::cout << "Instance created successfully!!\n";
		}

		fpGetPhysicalDeviceProperties2 =
			(PFN_vkGetPhysicalDeviceProperties2)vkGetInstanceProcAddr(
				instance, "vkGetPhysicalDeviceProperties2");
		if (fpGetPhysicalDeviceProperties2 == NULL) {
			throw std::runtime_error(
				"Vulkan: Proc address for \"vkGetPhysicalDeviceProperties2KHR\" not "
				"found.\n");
		}

#ifdef _WIN64
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
#endif
	}

	void initVulkan() {
		createInstance();
		setupDebugCallback();
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
		createVertexBuffer();
		createUniformBuffer();
		createDescriptorPool();
		createDescriptorSet();
		createCommandBuffers();
		createSyncObjects();
		createSyncObjectsExt();
	}

	void initOpenCL() {
		setOpenCLVkDevice();
		OpenCLVkImportVertexMem();
		OpenCLInitVertexMem();
		OpenCLVkImportSemaphore();
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
		memcpy(vk_uuid, vkDeviceUUID, sizeof(vkDeviceUUID));
		std::cout << "vkDeviceUUID:" << std::endl;
		for (int i = 0; i < sizeof(vkDeviceUUID); i++) {
			printf("%x", vkDeviceUUID[i]);
		}
		std::cout << std::endl;
	}

	int setOpenCLVkDevice() {
		int current_device = 0;
		int device_count = 0;
		int devices_prohibited = 0;
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
		printf("num_platforms=%d\n", num_platforms);
		if (errNum != CL_SUCCESS) {
			printf("Error: Failed to get number of platform\n");
			return errNum;
		}

		platforms = (cl_platform_id*)malloc(num_platforms * sizeof(cl_platform_id));
		if (!platforms) {
			printf("error allocating memory\n");
			return CL_OUT_OF_HOST_MEMORY;
		}

		// get the platform ID
		errNum = clGetPlatformIDs(num_platforms, platforms, NULL);
		if (errNum != CL_SUCCESS) {
			printf("Error: Failed to get platform\n");
			return errNum;
		}

		//Search for nvidia platform
		for (i = 0; i < num_platforms; i++) {
			//get platform information
			errNum = clGetPlatformInfo(platforms[i], CL_PLATFORM_VENDOR, bufsize, buf, NULL);
			if (CL_SUCCESS != errNum) {
				printf("Error:Failed to get platform info");
				return errNum;
			}
			if (NULL != strstr(buf, "NVIDIA Corporation")) {
				printf("found Nvidia platform\n");
				break;
			}
		}

		// Check whether there is any nvidia platform or not
		if (i >= num_platforms) {
			printf("Invalid platform\n");
			return CL_INVALID_PLATFORM;
		}

		errNum = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, 0, NULL, &num_devices);
		if (CL_SUCCESS != errNum) {
			printf("clGetDeviceIDs failed in returning of devices\n");
			return errNum;
		}
		devices = (cl_device_id*)malloc(num_devices * sizeof(cl_device_id));
		if (NULL == devices) {
			printf("Unable to allocate memory for devices\n");
			return CL_OUT_OF_HOST_MEMORY;
		}
		errNum = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, num_devices, devices, NULL);
		if (CL_SUCCESS != errNum) {
			printf("Failed to get deviceID.\n");
			return errNum;
		}
		contextProperties[1] = (cl_context_properties)platforms[i];
		opencl_platform = platforms[i];
		printf("Assigned contextproperties for platform\n");
		for (device_no = 0; device_no < num_devices; device_no++) {
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_EXTENSIONS, 0, NULL, &extensionSize);
			if (CL_SUCCESS != errNum) {
				printf("Error in clGetDeviceInfo for getting device_extension size....\n");
				return errNum;
			}
			extensions = (char*)malloc(extensionSize);
			if (NULL == extensions) {
				printf("Unable to allocate memory for extensions\n");
				return CL_OUT_OF_HOST_MEMORY;
			}
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_EXTENSIONS, extensionSize, extensions, NULL/*&extensionSize*/);
			if (CL_SUCCESS != errNum) {
				printf("Error in clGetDeviceInfo for getting device_extension \n");
				return errNum;
			}
			errNum = clGetDeviceInfo(devices[device_no], CL_DEVICE_UUID_KHR, CL_UUID_SIZE_KHR, uuid, &extensionSize);
			if (CL_SUCCESS != errNum) {
				printf("clGetDeviceInfo failed with error=%d\n", errNum);
				return errNum;
			}
			errNum = memcmp(uuid, vk_uuid, VK_UUID_SIZE);
			if (errNum == 0) {
				std::cout << "Assigned conextproperties for UUID=";
				for (int i = 0; i < VK_UUID_SIZE; i++) {
					printf("%x", uuid[i]);
				}
				std::cout << std::endl;
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
		if (CL_SUCCESS != errNum) {
			printf("erorr creating context=%d\n", errNum);
			return errNum;
		}
		printf("Successfully created context !!!\n");
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

		return indices.isComplete() && extensionsSupported && swapChainAdequate;
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
		const std::vector<VkPresentModeKHR> availablePresentModes) {
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
			VkExtent2D actualExtent = { WIDTH, HEIGHT };

			actualExtent.width = std::max(
				capabilities.minImageExtent.width,
				std::min(capabilities.maxImageExtent.width, actualExtent.width));
			actualExtent.height = std::max(
				capabilities.minImageExtent.height,
				std::min(capabilities.maxImageExtent.height, actualExtent.height));

			return actualExtent;
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
			createInfo.queueFamilyIndexCount = 0;      // Optional
			createInfo.pQueueFamilyIndices = nullptr;  // Optional
		}

		createInfo.preTransform = swapChainSupport.capabilities.currentTransform;
		createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
		createInfo.presentMode = presentMode;
		createInfo.clipped = VK_TRUE;
		createInfo.oldSwapchain = VK_NULL_HANDLE;

		if (vkCreateSwapchainKHR(device, &createInfo, nullptr, &swapChain) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create swap chain!");
		}
		else {
			std::cout << "Swapchain created!!\n";
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
			VkImageViewCreateInfo createInfo = {};
			createInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
			createInfo.image = swapChainImages[i];
			createInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
			createInfo.format = swapChainImageFormat;

			createInfo.components.r = VK_COMPONENT_SWIZZLE_IDENTITY;
			createInfo.components.g = VK_COMPONENT_SWIZZLE_IDENTITY;
			createInfo.components.b = VK_COMPONENT_SWIZZLE_IDENTITY;
			createInfo.components.a = VK_COMPONENT_SWIZZLE_IDENTITY;

			createInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
			createInfo.subresourceRange.baseMipLevel = 0;
			createInfo.subresourceRange.levelCount = 1;
			createInfo.subresourceRange.baseArrayLayer = 0;
			createInfo.subresourceRange.layerCount = 1;

			if (vkCreateImageView(device, &createInfo, nullptr,
				&swapChainImageViews[i]) != VK_SUCCESS) {
				throw std::runtime_error("failed to create image views!");
			}
		}
	}

	void createDescriptorSetLayout() {
		VkDescriptorSetLayoutBinding uboLayoutBinding = {};
		uboLayoutBinding.binding = 0;
		uboLayoutBinding.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		uboLayoutBinding.descriptorCount = 1;
		uboLayoutBinding.stageFlags = VK_SHADER_STAGE_VERTEX_BIT;
		uboLayoutBinding.pImmutableSamplers = nullptr;  // Optional

		VkDescriptorSetLayoutCreateInfo layoutInfo = {};
		layoutInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = 1;
		layoutInfo.pBindings = &uboLayoutBinding;

		if (vkCreateDescriptorSetLayout(device, &layoutInfo, nullptr,
			&descriptorSetLayout) != VK_SUCCESS) {
			throw std::runtime_error("failed to create descriptor set layout!");
		}
	}

	void createGraphicsPipeline() {

		auto vertShaderCode = readFile("shader_sine.vert");
		auto fragShaderCode = readFile("shader_sine.frag");

		VkShaderModule vertShaderModule;
		VkShaderModule fragShaderModule;

		vertShaderModule = createShaderModule(vertShaderCode);
		fragShaderModule = createShaderModule(fragShaderCode);

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
		vertexInputInfo.pVertexBindingDescriptions = &bindingDescription;
		vertexInputInfo.vertexAttributeDescriptionCount =
			static_cast<uint32_t>(attributeDescriptions.size());
		vertexInputInfo.pVertexAttributeDescriptions = attributeDescriptions.data();

		VkPipelineInputAssemblyStateCreateInfo inputAssembly = {};
		inputAssembly.sType =
			VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
		inputAssembly.topology = VK_PRIMITIVE_TOPOLOGY_POINT_LIST;
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
		rasterizer.depthBiasConstantFactor = 0.0f;  // Optional
		rasterizer.depthBiasClamp = 0.0f;           // Optional
		rasterizer.depthBiasSlopeFactor = 0.0f;     // Optional

		VkPipelineMultisampleStateCreateInfo multisampling = {};
		multisampling.sType =
			VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
		multisampling.sampleShadingEnable = VK_FALSE;
		multisampling.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;
		multisampling.minSampleShading = 1.0f;           // Optional
		multisampling.pSampleMask = nullptr;             // Optional
		multisampling.alphaToCoverageEnable = VK_FALSE;  // Optional
		multisampling.alphaToOneEnable = VK_FALSE;       // Optional

		VkPipelineColorBlendAttachmentState colorBlendAttachment = {};
		colorBlendAttachment.colorWriteMask =
			VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
			VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
		colorBlendAttachment.blendEnable = VK_FALSE;
		colorBlendAttachment.srcColorBlendFactor = VK_BLEND_FACTOR_ONE;  // Optional
		colorBlendAttachment.dstColorBlendFactor =
			VK_BLEND_FACTOR_ZERO;                                        // Optional
		colorBlendAttachment.colorBlendOp = VK_BLEND_OP_ADD;             // Optional
		colorBlendAttachment.srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE;  // Optional
		colorBlendAttachment.dstAlphaBlendFactor =
			VK_BLEND_FACTOR_ZERO;                             // Optional
		colorBlendAttachment.alphaBlendOp = VK_BLEND_OP_ADD;  // Optional

		VkPipelineColorBlendStateCreateInfo colorBlending = {};
		colorBlending.sType =
			VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
		colorBlending.logicOpEnable = VK_FALSE;
		colorBlending.logicOp = VK_LOGIC_OP_COPY;  // Optional
		colorBlending.attachmentCount = 1;
		colorBlending.pAttachments = &colorBlendAttachment;
		colorBlending.blendConstants[0] = 0.0f;  // Optional
		colorBlending.blendConstants[1] = 0.0f;  // Optional
		colorBlending.blendConstants[2] = 0.0f;  // Optional
		colorBlending.blendConstants[3] = 0.0f;  // Optional

#if 0
		VkDynamicState dynamicStates[] = {
			VK_DYNAMIC_STATE_VIEWPORT,
			VK_DYNAMIC_STATE_LINE_WIDTH
		};

		VkPipelineDynamicStateCreateInfo dynamicState = {};
		dynamicState.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
		dynamicState.dynamicStateCount = 2;
		dynamicState.pDynamicStates = dynamicStates;
#endif
		VkPipelineLayoutCreateInfo pipelineLayoutInfo = {};
		pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
		pipelineLayoutInfo.setLayoutCount = 1;                  // Optional
		pipelineLayoutInfo.pSetLayouts = &descriptorSetLayout;  // Optional
		pipelineLayoutInfo.pushConstantRangeCount = 0;          // Optional
		pipelineLayoutInfo.pPushConstantRanges = nullptr;       // Optional

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
		pipelineInfo.pDepthStencilState = nullptr;  // Optional
		pipelineInfo.pColorBlendState = &colorBlending;
		pipelineInfo.pDynamicState = nullptr;  // Optional
		pipelineInfo.layout = pipelineLayout;
		pipelineInfo.renderPass = renderPass;
		pipelineInfo.subpass = 0;
		pipelineInfo.basePipelineHandle = VK_NULL_HANDLE;  // Optional
		pipelineInfo.basePipelineIndex = -1;               // Optional

		if (vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, &pipelineInfo,
			nullptr, &graphicsPipeline) != VK_SUCCESS) {
			throw std::runtime_error("failed to create graphics pipeline!");
		}
		else {
			std::cout << "Pipeline created successfully!!\n";
		}
		vkDestroyShaderModule(device, fragShaderModule, nullptr);
		vkDestroyShaderModule(device, vertShaderModule, nullptr);
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

		VkRenderPassCreateInfo renderPassInfo = {};
		renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
		renderPassInfo.attachmentCount = 1;
		renderPassInfo.pAttachments = &colorAttachment;
		renderPassInfo.subpassCount = 1;
		renderPassInfo.pSubpasses = &subpass;

		VkSubpassDependency dependency = {};
		dependency.srcSubpass = VK_SUBPASS_EXTERNAL;
		dependency.dstSubpass = 0;
		dependency.srcStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
		dependency.srcAccessMask = 0;
		dependency.dstStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
		dependency.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_READ_BIT |
			VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
		renderPassInfo.dependencyCount = 1;
		renderPassInfo.pDependencies = &dependency;

		if (vkCreateRenderPass(device, &renderPassInfo, nullptr, &renderPass) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create render pass!");
		}
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
		poolInfo.flags = 0;  // Optional

		if (vkCreateCommandPool(device, &poolInfo, nullptr, &commandPool) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create command pool!");
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

	void createBufferExtMem(VkDeviceSize size, VkBufferUsageFlags usage,
		VkMemoryPropertyFlags properties,
		VkExternalMemoryHandleTypeFlagsKHR extMemHandleType,
		VkBuffer& buffer, VkDeviceMemory& bufferMemory) {
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

#ifdef _WIN64
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
#ifdef _WIN64
		vulkanExportMemoryAllocateInfoKHR.pNext =
			extMemHandleType & VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR
			? &vulkanExportMemoryWin32HandleInfoKHR
			: NULL;
		vulkanExportMemoryAllocateInfoKHR.handleTypes = extMemHandleType;
#else
		vulkanExportMemoryAllocateInfoKHR.pNext = NULL;
		vulkanExportMemoryAllocateInfoKHR.handleTypes =
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT;
#endif
		VkMemoryAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
		allocInfo.pNext = &vulkanExportMemoryAllocateInfoKHR;
		allocInfo.allocationSize = memRequirements.size;
		allocInfo.memoryTypeIndex =
			findMemoryType(memRequirements.memoryTypeBits, properties);

		if (vkAllocateMemory(device, &allocInfo, nullptr, &bufferMemory) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate external buffer memory!");
		}

		vkBindBufferMemory(device, buffer, bufferMemory, 0);
	}

	void createVertexBuffer() {
		mesh_width = swapChainExtent.width / 2;
		mesh_height = swapChainExtent.height / 2;
		vertexBufSize = mesh_height * mesh_width;

		VkDeviceSize bufferSize = sizeof(Vertex) * vertexBufSize;
#ifdef _WIN64
		if (IsWindows8OrGreater()) {
			createBufferExtMem(bufferSize, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
				VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
				VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT,
				vertexBuffer, vertexBufferMemory);
		}
		else {
			createBufferExtMem(bufferSize, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
				VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
				VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
				vertexBuffer, vertexBufferMemory);
		}
#else
		createBufferExtMem(bufferSize, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
			VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT,
			vertexBuffer, vertexBufferMemory);
#endif
	}

	int OpenCLInitVertexMem() {

		size_t cb;
		cl_device_id* devices;

		cl_int err;
		clGetContextInfo(context, CL_CONTEXT_DEVICES, 0, NULL, &cb);
		devices = (cl_device_id*)malloc(cb);
		clGetContextInfo(context, CL_CONTEXT_DEVICES, cb, devices, NULL);

		cmd_queue = clCreateCommandQueue(context, deviceId, 0, NULL);
		if (cmd_queue == (cl_command_queue)0) {
			printf("Error: Failed to create command queue!\n");
			return CL_INVALID_COMMAND_QUEUE;
		}

		Vertex* vertices = (Vertex*)clExternalmemVertexBuffer;
		const int SOURCE_NUM_LINES = sizeof(kernel_text) / sizeof(kernel_text[0]);
		program = clCreateProgramWithSource(
			context,
			SOURCE_NUM_LINES,
			kernel_text, NULL, NULL);

		err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
		if (err != CL_SUCCESS)
		{
			printf("Error: Failed to build program=%d\n", err);
			return err;
		}
		// create the kernel
		kernel = clCreateKernel(program, "sinewave_gen_kernel", &err);
		if (0 != checkResult(err, "clCreateKernel"))
		{
			printf("Error: failed to create kernel\n");
			return err;
		}

		// set the args values
		err = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&vertices);
		err |= clSetKernelArg(kernel, 1, sizeof(unsigned int), (void *)&mesh_width);
		err |= clSetKernelArg(kernel, 2, sizeof(unsigned int), (void *)&mesh_height);
		err |= clSetKernelArg(kernel, 3, sizeof(cl_double), (void *)&AnimTime);

		if (err != CL_SUCCESS)
		{
			printf("Error: Failed to set arg values\n");
			return err;
		}
		//printf("mesh_width=%d and mesh_width=%d\n", mesh_width, mesh_height);
		size_t local_work_size[3] = { 16, 16, 1 };
		size_t global_work_size[3] = { mesh_width, 288, 1 };

		err = clEnqueueNDRangeKernel(cmd_queue, kernel, 3, NULL,
			global_work_size, local_work_size,
			0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueNDRangeKernel")) {
			throw std::runtime_error("Failed clEnqueueNDRangeKernel!");
		}
		clFinish(cmd_queue);
	}

	void createUniformBuffer() {
		VkDeviceSize bufferSize = sizeof(UniformBufferObject);
		createBuffer(bufferSize, VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
			VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
			VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
			uniformBuffer, uniformBufferMemory);
	}

	uint32_t findMemoryType(uint32_t typeFilter,
		VkMemoryPropertyFlags properties) {
		VkPhysicalDeviceMemoryProperties memProperties;
		vkGetPhysicalDeviceMemoryProperties(physicalDevice, &memProperties);

		for (uint32_t i = 0; i < memProperties.memoryTypeCount; i++) {
			if (typeFilter & (1 << i) && (memProperties.memoryTypes[i].propertyFlags &
				properties) == properties) {
				return i;
			}
		}

		throw std::runtime_error("failed to find suitable memory type!");
	}

	void getKhrExtensionsFn() {
#ifdef _WIN64

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
			beginInfo.pInheritanceInfo = nullptr;  // Optional

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
			vkCmdBindDescriptorSets(commandBuffers[i],
				VK_PIPELINE_BIND_POINT_GRAPHICS, pipelineLayout,
				0, 1, &descriptorSet, 0, nullptr);
			vkCmdDraw(commandBuffers[i], static_cast<uint32_t>(vertexBufSize), 1, 0,
				0);
			vkCmdEndRenderPass(commandBuffers[i]);
			if (vkEndCommandBuffer(commandBuffers[i]) != VK_SUCCESS) {
				throw std::runtime_error("failed to record command buffer!");
			}
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

	static std::vector<char> readFile(const std::string& filename) {
		char* file_path = sdkFindFilePath(filename.c_str(), execution_path.c_str());

		std::ifstream file(file_path, std::ios::ate | std::ios::binary);

		if (!file.is_open()) {
			throw std::runtime_error("failed to open shader spv file!\n");
		}
		size_t fileSize = (size_t)file.tellg();
		std::vector<char> buffer(fileSize);
		file.seekg(0);
		file.read(buffer.data(), fileSize);
		file.close();

		return buffer;
		printf("readfile end!!!\n");
	}

	void mainLoop() {

		clEnqueueWaitSemaphoresKHRptr = (pfnclEnqueueWaitSemaphoresKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueWaitSemaphoresKHR");
		if (NULL == clEnqueueWaitSemaphoresKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clEnqueueWaitSemaphoresKHRptr!");
		}
		clEnqueueAcquireExternalMemObjectsKHRptr = (pfnclEnqueueAcquireExternalMemObjectsKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueAcquireExternalMemObjectsKHR");
		if (NULL == clEnqueueAcquireExternalMemObjectsKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clEnqueueAcquireExternalMemObjectsKHRptr!");
		}
		clEnqueueReleaseExternalMemObjectsKHRptr = (pfnclEnqueueReleaseExternalMemObjectsKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueReleaseExternalMemObjectsKHR");
		if (NULL == clEnqueueReleaseExternalMemObjectsKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clEnqueueReleaseExternalMemObjectsKHRptr!");
		}
		clEnqueueSignalSemaphoresKHRptr = (pfnclEnqueueSignalSemaphoresKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clEnqueueSignalSemaphoresKHR");
		if (NULL == clEnqueueSignalSemaphoresKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clEnqueueSignalSemaphoresKHRptr!");
		}
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
		printf("number of frames per second is %f", frames_per_sec);
		vkDeviceWaitIdle(device);
	}

	void updateUniformBuffer() {

		UniformBufferObject ubo = {};

		mat4x4_identity(ubo.model);
		mat4x4 Model;
		mat4x4_dup(Model, ubo.model);
		mat4x4_rotate(ubo.model, Model, 1.0f, 0.0f, 1.0f, degreesToRadians(45.0f));

		vec3 eye = { 2.0f, 2.0f, 2.0f };
		vec3 center = { 0.0f, 0.0f, 0.0f };
		vec3 up = { 0.0f, 0.0f, 1.0f };
		mat4x4_look_at(ubo.view, eye, center, up);
		mat4x4_perspective(ubo.proj, degreesToRadians(45.0f),
			swapChainExtent.width / (float)swapChainExtent.height,
			0.1f, 10.0f);
		ubo.proj[1][1] *= -1;
		void* data;
		vkMapMemory(device, uniformBufferMemory, 0, sizeof(ubo), 0, &data);
		memcpy(data, &ubo, sizeof(ubo));
		vkUnmapMemory(device, uniformBufferMemory);
	}

	void createDescriptorPool() {
		VkDescriptorPoolSize poolSize = {};
		poolSize.type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		poolSize.descriptorCount = 1;

		VkDescriptorPoolCreateInfo poolInfo = {};
		poolInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
		poolInfo.poolSizeCount = 1;
		poolInfo.pPoolSizes = &poolSize;
		poolInfo.maxSets = 1;

		if (vkCreateDescriptorPool(device, &poolInfo, nullptr, &descriptorPool) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to create descriptor pool!");
		}
	}

	void createDescriptorSet() {
		VkDescriptorSetLayout layouts[] = { descriptorSetLayout };
		VkDescriptorSetAllocateInfo allocInfo = {};
		allocInfo.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocInfo.descriptorPool = descriptorPool;
		allocInfo.descriptorSetCount = 1;
		allocInfo.pSetLayouts = layouts;

		if (vkAllocateDescriptorSets(device, &allocInfo, &descriptorSet) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to allocate descriptor set!");
		}

		VkDescriptorBufferInfo bufferInfo = {};
		bufferInfo.buffer = uniformBuffer;
		bufferInfo.offset = 0;
		bufferInfo.range = sizeof(UniformBufferObject);

		VkWriteDescriptorSet descriptorWrite = {};
		descriptorWrite.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		descriptorWrite.dstSet = descriptorSet;
		descriptorWrite.dstBinding = 0;
		descriptorWrite.dstArrayElement = 0;
		descriptorWrite.descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		descriptorWrite.descriptorCount = 1;
		descriptorWrite.pBufferInfo = &bufferInfo;
		descriptorWrite.pImageInfo = nullptr;        // Optional
		descriptorWrite.pTexelBufferView = nullptr;  // Optional

		vkUpdateDescriptorSets(device, 1, &descriptorWrite, 0, nullptr);
	}

	void drawFrame() {

		uint32_t imageIndex;
		vkAcquireNextImageKHR(device, swapChain,
			std::numeric_limits<uint64_t>::max(),
			imageAvailableSemaphore, VK_NULL_HANDLE, &imageIndex);

		if (!startSubmit) {
			submitVulkan(imageIndex);
			startSubmit = 1;
		}
		else {
			submitVulkanOpencl(imageIndex);
		}

		VkPresentInfoKHR presentInfo = {};
		presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphore };

		presentInfo.waitSemaphoreCount = 1;
		presentInfo.pWaitSemaphores = signalSemaphores;

		VkSwapchainKHR swapChains[] = { swapChain };
		presentInfo.swapchainCount = 1;
		presentInfo.pSwapchains = swapChains;
		presentInfo.pImageIndices = &imageIndex;
		presentInfo.pResults = nullptr;  // Optional

		vkQueuePresentKHR(presentQueue, &presentInfo);

		OpenCLUpdateVertexBuffer();
		// Added sleep of 5 millisecs so that CPU does not submit too much work to
		// GPU
		std::this_thread::sleep_for(std::chrono::microseconds(5000));

	}

	void submitVulkan(uint32_t imageIndex) {
		VkSubmitInfo submitInfo = {};
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;

		VkSemaphore waitSemaphores[] = { imageAvailableSemaphore };
		VkPipelineStageFlags waitStages[] = {
			VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT };
		submitInfo.waitSemaphoreCount = 1;
		submitInfo.pWaitSemaphores = waitSemaphores;
		submitInfo.pWaitDstStageMask = waitStages;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = &commandBuffers[imageIndex];

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphore,
										  vkUpdateClVertexBufSemaphore };

		submitInfo.signalSemaphoreCount = 2;
		submitInfo.pSignalSemaphores = signalSemaphores;

		if (vkQueueSubmit(graphicsQueue, 1, &submitInfo, VK_NULL_HANDLE) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to submit draw command buffer!");
		}
	}

	void submitVulkanOpencl(uint32_t imageIndex) {
		VkSubmitInfo submitInfo = {};
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;

		VkSemaphore waitSemaphores[] = { imageAvailableSemaphore,
										clUpdateVkVertexBufSemaphore };
		VkPipelineStageFlags waitStages[] = {
			VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
			VK_PIPELINE_STAGE_ALL_COMMANDS_BIT };
		submitInfo.waitSemaphoreCount = 2;
		submitInfo.pWaitSemaphores = waitSemaphores;
		submitInfo.pWaitDstStageMask = waitStages;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = &commandBuffers[imageIndex];

		VkSemaphore signalSemaphores[] = { renderFinishedSemaphore,
										  vkUpdateClVertexBufSemaphore };

		submitInfo.signalSemaphoreCount = 2;
		submitInfo.pSignalSemaphores = signalSemaphores;

		if (vkQueueSubmit(graphicsQueue, 1, &submitInfo, VK_NULL_HANDLE) !=
			VK_SUCCESS) {
			throw std::runtime_error("failed to submit draw command buffer!");
		}
	}

	void createSyncObjects() {
		VkSemaphoreCreateInfo semaphoreInfo = {};
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

		if (vkCreateSemaphore(device, &semaphoreInfo, nullptr,
			&imageAvailableSemaphore) != VK_SUCCESS ||
			vkCreateSemaphore(device, &semaphoreInfo, nullptr,
				&renderFinishedSemaphore) != VK_SUCCESS) {
			throw std::runtime_error(
				"failed to create synchronization objects for a frame!");
		}
	}

	void createSyncObjectsExt() {
		VkSemaphoreCreateInfo semaphoreInfo = {};
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

		memset(&semaphoreInfo, 0, sizeof(semaphoreInfo));
		semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

#ifdef _WIN64
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
#ifdef _WIN64
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
			&clUpdateVkVertexBufSemaphore) != VK_SUCCESS ||
			vkCreateSemaphore(device, &semaphoreInfo, nullptr,
				&vkUpdateClVertexBufSemaphore) != VK_SUCCESS) {
			throw std::runtime_error(
				"failed to create synchronization objects for a OpenCL-Vulkan!");
		}
	}

	void OpenCLVkImportVertexMem() {

		cl_external_mem_desc_khr extMem_desc = { };
		cl_int err = 0;
		void* handle = NULL;
		cl_device_id devList[] = {deviceId, NULL};
		std::vector< cl_mem_properties_khr >extMemProperties;

        extMemProperties.push_back((cl_mem_properties_khr)CL_DEVICE_HANDLE_LIST_KHR);
        extMemProperties.push_back((cl_mem_properties_khr)devList[0]);
        extMemProperties.push_back((cl_mem_properties_khr)CL_DEVICE_HANDLE_LIST_END_KHR);
#ifdef _WIN64
		if (!isExtensionAvailable(devList[0], "cl_khr_external_memory_win32")) {
			throw std::runtime_error(" Device does not support cl_khr_external_memory_win32 extension \n");
		}
		err = check_external_memory_handle_type(devList[0], (IsWindows8OrGreater() ? CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KHR
			: CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KMT_KHR));
		extMemProperties.push_back((cl_mem_properties_khr)(IsWindows8OrGreater() ? CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KHR    
			: CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_WIN32_KMT_KHR));
		handle = getVkMemHandle(
			IsWindows8OrGreater()
			? VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT);
		extMemProperties.push_back((cl_mem_properties_khr)handle);
#else
		if (!isExtensionAvailable(devList[0], "cl_khr_external_memory_opaque_fd")) {
			throw std::runtime_error(" Device does not support cl_khr_external_memory_opaque_fd extension \n");
	}
		err = check_external_memory_handle_type(devList[0], CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_FD_KHR);
		extMemProperties.push_back((cl_mem_properties_khr)CL_EXTERNAL_MEMORY_HANDLE_OPAQUE_FD_KHR);
		int fd = getVkMemHandle(VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT);
		if (-1 == fd) {
			throw std::runtime_error("failed to get handle!");
		}
		extMemProperties.push_back((cl_mem_properties_khr)fd);
#endif
		if (CL_SUCCESS != err) {
			throw std::runtime_error("Unsupported external memory type\n ");
		}
		extMemProperties.push_back(0);

		clExternalmemVertexBuffer = clCreateBufferWithProperties(context, extMemProperties.data(), 1, sizeof(Vertex) * vertexBufSize, NULL, &err);
		if (0 != checkResult(err, "clCreateBufferWithProperties")) {
			throw std::runtime_error("clCreateBufferWithProperties failed!");
		}
		printf("OpenCL Imported Vulkan vertex buffer\n");
	}

	void OpenCLVkImportSemaphore() {

		cl_int err = 0;
		void* handle = NULL;
		cl_device_id devList[] = { deviceId, NULL };
        std::vector< cl_semaphore_properties_khr >sema_props { 
         (cl_semaphore_properties_khr)CL_SEMAPHORE_TYPE_KHR, 
         (cl_semaphore_properties_khr)CL_SEMAPHORE_TYPE_BINARY,
		};

        sema_props.push_back((cl_semaphore_properties_khr)CL_DEVICE_HANDLE_LIST_KHR);
        sema_props.push_back((cl_semaphore_properties_khr)devList[0]);
        sema_props.push_back((cl_semaphore_properties_khr)CL_DEVICE_HANDLE_LIST_END_KHR);
#ifdef _WIN64
		if (!isExtensionAvailable(devList[0], "cl_khr_external_semaphore_win32")) {
			throw std::runtime_error(" Device does not support cl_khr_external_semaphore_win32 extension \n");
		}
		err = check_external_semaphore_handle_type(devList[0], IsWindows8OrGreater() ? CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KHR
			: CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KMT_KHR);
		sema_props.push_back((cl_semaphore_properties_khr)(IsWindows8OrGreater() ? CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KHR
			: CL_SEMAPHORE_HANDLE_OPAQUE_WIN32_KMT_KHR));
		handle  = getVkSemaphoreHandle(
			IsWindows8OrGreater()
			? VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
			clUpdateVkVertexBufSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)handle);
#else
		if (!isExtensionAvailable(devList[0], "cl_khr_external_semaphore_opaque_fd")) {
			throw std::runtime_error(" Device does not support cl_khr_external_semaphore_opaque_fd extension \n");
		}
		err = check_external_semaphore_handle_type(devList[0], CL_SEMAPHORE_HANDLE_OPAQUE_FD_KHR);
		sema_props.push_back((cl_semaphore_properties_khr)CL_SEMAPHORE_HANDLE_OPAQUE_FD_KHR);
		int fd = getVkSemaphoreHandle(VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT,
			clUpdateVkVertexBufSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)fd);
#endif
		if (CL_SUCCESS != err) {
			throw std::runtime_error("Unsupported external sempahore handle type\n ");
		}
		sema_props.push_back(0);
		clCreateSemaphoreWithPropertiesKHRptr = (pfnclCreateSemaphoreWithPropertiesKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clCreateSemaphoreWithPropertiesKHR");
		if (NULL == clCreateSemaphoreWithPropertiesKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clCreateSemaphoreWithPropertiesKHR!");
		}
		clOpenCLUpdateVkVertexBufSemaphore = clCreateSemaphoreWithPropertiesKHRptr(context, sema_props.data(), &err);
		if (0 != checkResult(err, "clCreateSemaphoreWithPropertiesKHR")) {
			throw std::runtime_error("clCreateSemaphoreWithPropertiesKHR failed!");
		}
		sema_props.pop_back();
		sema_props.pop_back();
#ifdef _WIN64     
		handle = getVkSemaphoreHandle(
			IsWindows8OrGreater()
			? VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT
			: VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
			vkUpdateClVertexBufSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)handle);
#else
		fd = getVkSemaphoreHandle(VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT, vkUpdateClVertexBufSemaphore);
		sema_props.push_back((cl_semaphore_properties_khr)fd);
#endif
		sema_props.push_back(0);
		clVkUpdateOpenCLVertexBufSemaphore = clCreateSemaphoreWithPropertiesKHRptr(context, sema_props.data(), &err);
		//check for error
		if (0 != checkResult(err, "clCreateSemaphoreWithPropertiesKHR")) {
			throw std::runtime_error("clCreateSemaphoreWithPropertiesKHR failed!");
		}

		printf("OpenCL Imported Vulkan semaphore\n");
	}

#ifdef _WIN64  // For windows
	HANDLE getVkMemHandle(
		VkExternalMemoryHandleTypeFlagsKHR externalMemoryHandleType) {
		HANDLE handle;

		VkMemoryGetWin32HandleInfoKHR vkMemoryGetWin32HandleInfoKHR = {};
		vkMemoryGetWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
		vkMemoryGetWin32HandleInfoKHR.pNext = NULL;
		vkMemoryGetWin32HandleInfoKHR.memory = vertexBufferMemory;
		vkMemoryGetWin32HandleInfoKHR.handleType =
			(VkExternalMemoryHandleTypeFlagBitsKHR)externalMemoryHandleType;

		fpGetMemoryWin32HandleKHR(device, &vkMemoryGetWin32HandleInfoKHR, &handle);
		return handle;
	}
#else
	int getVkMemHandle(
		VkExternalMemoryHandleTypeFlagsKHR externalMemoryHandleType) {
		if (externalMemoryHandleType ==
			VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT) {
			int fd;

			VkMemoryGetFdInfoKHR vkMemoryGetFdInfoKHR = {};
			vkMemoryGetFdInfoKHR.sType = VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR;
			vkMemoryGetFdInfoKHR.pNext = NULL;
			vkMemoryGetFdInfoKHR.memory = vertexBufferMemory;
			vkMemoryGetFdInfoKHR.handleType =
				VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

			fpGetMemoryFdKHR(device, &vkMemoryGetFdInfoKHR, &fd);

			return fd;
		}
		return -1;
	}
#endif

#ifdef _WIN64
	HANDLE getVkSemaphoreHandle(
		VkExternalSemaphoreHandleTypeFlagBitsKHR externalSemaphoreHandleType,
		VkSemaphore& semVkCl) {
		HANDLE handle;

		VkSemaphoreGetWin32HandleInfoKHR vulkanSemaphoreGetWin32HandleInfoKHR = {};
		vulkanSemaphoreGetWin32HandleInfoKHR.sType =
			VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
		vulkanSemaphoreGetWin32HandleInfoKHR.pNext = NULL;
		vulkanSemaphoreGetWin32HandleInfoKHR.semaphore = semVkCl;
		vulkanSemaphoreGetWin32HandleInfoKHR.handleType =
			externalSemaphoreHandleType;

		fpGetSemaphoreWin32HandleKHR(device, &vulkanSemaphoreGetWin32HandleInfoKHR,
			&handle);

		return handle;
	}
#else
	int getVkSemaphoreHandle(
		VkExternalSemaphoreHandleTypeFlagBitsKHR externalSemaphoreHandleType,
		VkSemaphore& semVkCl) {
		if (externalSemaphoreHandleType ==
			VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT) {
			int fd;

			VkSemaphoreGetFdInfoKHR vulkanSemaphoreGetFdInfoKHR = {};
			vulkanSemaphoreGetFdInfoKHR.sType =
				VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR;
			vulkanSemaphoreGetFdInfoKHR.pNext = NULL;
			vulkanSemaphoreGetFdInfoKHR.semaphore = semVkCl;
			vulkanSemaphoreGetFdInfoKHR.handleType =
				VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;

			fpGetSemaphoreFdKHR(device, &vulkanSemaphoreGetFdInfoKHR, &fd);

			return fd;
		}
		return -1;
	}
#endif

	void OpenCLUpdateVertexBuffer() {

		cl_int err = 0;

		err =clEnqueueWaitSemaphoresKHRptr(cmd_queue, 1, &clVkUpdateOpenCLVertexBufSemaphore, NULL, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueWaitSemaphoresKHR"))
		{
			throw std::runtime_error("Failed clEnqueueWaitSemaphoresKHR!");
		}

		err = clEnqueueAcquireExternalMemObjectsKHRptr(cmd_queue, 1, &clExternalmemVertexBuffer, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueAcquireExternalMemObjectsKHR"))
		{
			throw std::runtime_error("Failed clEnqueueAcquireExternalMemObjectsKHR!");
		}

		Vertex* pos = (Vertex*)clExternalmemVertexBuffer;
		AnimTime += 0.01f;

	        // set the args values
		err = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&pos);
		err |= clSetKernelArg(kernel, 3, sizeof(cl_double), (void *)&AnimTime);
		if (err != CL_SUCCESS)
		{
			throw std::runtime_error("Error: Failed to set arg values!");
		}
		size_t local_work_size[3] = { 16, 16, 1 };
		size_t global_work_size[3] = { mesh_width, 288, 1 };

		err = clEnqueueNDRangeKernel(cmd_queue, kernel, 3, NULL,
			global_work_size, local_work_size,
			0, NULL, NULL);
		//check for error.
		if (0 != checkResult(err, "clEnqueueNDRangeKernel")) {
			throw std::runtime_error("Failed clEnqueueNDRangeKernel!");
		}

		clFinish(cmd_queue);

		err = clEnqueueReleaseExternalMemObjectsKHRptr(cmd_queue, 1, &clExternalmemVertexBuffer, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueReleaseExternalMemObjectsKHR")) {
			throw std::runtime_error("Failed clEnqueueReleaseExternalMemObjectsKHR!");
		}

		err = clEnqueueSignalSemaphoresKHRptr(cmd_queue, 1, &clOpenCLUpdateVkVertexBufSemaphore, NULL, 0, NULL, NULL);
		if (0 != checkResult(err, "clEnqueueSignalSemaphoresKHR")) {
			throw std::runtime_error("Failed clEnqueueSignalSemaphoresKHRptr!");
		}
	}

	void cleanup() {
		if (enableValidationLayers) {
			DestroyDebugReportCallbackEXT(instance, callback, nullptr);
		}

		vkDestroySemaphore(device, renderFinishedSemaphore, nullptr);
		vkDestroySemaphore(device, imageAvailableSemaphore, nullptr);

		clReleaseSemaphoreObjectKHRptr = (pfnclReleaseSemaphoreObjectKHR)clGetExtensionFunctionAddressForPlatform(opencl_platform, "clReleaseSemaphoreObjectKHR");
		if (NULL == clReleaseSemaphoreObjectKHRptr) {
			throw std::runtime_error("Failed to get the function pointer of clReleaseSemaphoreObjectKHRptr!");
		}
		checkResult(
			clReleaseSemaphoreObjectKHRptr(clOpenCLUpdateVkVertexBufSemaphore), "clReleaseSemaphoreObjectKHR");
		checkResult(
			clReleaseSemaphoreObjectKHRptr(clVkUpdateOpenCLVertexBufSemaphore), "clReleaseSemaphoreObjectKHR");
		vkDestroySemaphore(device, clUpdateVkVertexBufSemaphore, nullptr);

		vkDestroySemaphore(device, vkUpdateClVertexBufSemaphore, nullptr);

		vkDestroyCommandPool(device, commandPool, nullptr);
		for (auto framebuffer : swapChainFramebuffers) {
			vkDestroyFramebuffer(device, framebuffer, nullptr);
		}
		for (auto imageView : swapChainImageViews) {
			vkDestroyImageView(device, imageView, nullptr);
		}
		vkDestroyPipeline(device, graphicsPipeline, nullptr);
		vkDestroyPipelineLayout(device, pipelineLayout, nullptr);
		vkDestroyDescriptorSetLayout(device, descriptorSetLayout, nullptr);
		vkDestroyBuffer(device, uniformBuffer, nullptr);
		vkFreeMemory(device, uniformBufferMemory, nullptr);
		vkDestroyRenderPass(device, renderPass, nullptr);
		vkDestroySwapchainKHR(device, swapChain, nullptr);
		vkDestroyBuffer(device, vertexBuffer, nullptr);
		vkFreeMemory(device, vertexBufferMemory, nullptr);
		vkDestroyDescriptorPool(device, descriptorPool, nullptr);
		vkDestroyDevice(device, nullptr);
		vkDestroySurfaceKHR(instance, surface, nullptr);
		vkDestroyInstance(instance, nullptr);
		glfwDestroyWindow(window);
		glfwTerminate();
	}
};

int main(int argc, char* argv[]) {
	execution_path = argv[0];
	vulkanOpenCLApp app;

	try {
		for (int i = 1;i < argc;i++)
		{
			if (strcmp(argv[i], "-n") == 0)
			{
				if (i + 1 < argc && isdigit(atoi(argv[i+1])))
					maxFrames = atoi(argv[i++]);
				else 
					throw std::runtime_error("Enter integer as -n argument");
			}
		}
		maxFrames = maxFrames <= UINT_MAX ? maxFrames : 1000;
		app.run();
	}
	catch (const std::runtime_error& e) {
		std::cerr << e.what() << std::endl;
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
