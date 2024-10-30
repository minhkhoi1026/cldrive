For windows : 

->Set $(ROOTDIR) to VK_OCL_Interop_samples folder after unzipping VK_OCL_Interop_samples.zip

For simpleVulkan::
1.Build simpleVulkan using .sln file inside "$(ROOTDIR)\OpenCL\src\simpleVulkan
2.Binary will be created in "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
3.Copy glfw3.dll from $(ROOTDIR)\shared\lib\x86_64_win32\ to "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
4.Copy shader_sine.frag and shader_sine.vert from "$(ROOTDIR)\OpenCL\src\simpleVulkan\" to "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
5.Run the simpleVulkan.exe.

For vulkanImageOpenCL::
1.Build vulkanImageOpenCL using .sln file inside "$(ROOTDIR)\OpenCL\src\vulkanImageOpenCL
2.Binary will be created in "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
3.Copy glfw3.dll from $(ROOTDIR)\shared\lib\x86_64_win32\ to "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
4.Copy shader.frag, shader.vert and lenaRGB.ppm from "$(ROOTDIR)\OpenCL\src\vulkanImageOpenCL\" to "$(ROOTDIR)\OpenCL\bin\x86_64_win32_(release\debug)"
4.Run the vulkanImageOpenCL.exe.


For linux:

1.cd to $(ROOTDIR)\OpenCL
2.make 
3.Binaries will be created inside OpenCL/bin/x86_64_linux_Release folder
4.Copy shader_sine.frag and shader_sine.vert from "$(ROOTDIR)\OpenCL\src\simpleVulkan\" to "$(ROOTDIR)\OpenCL\bin\x86_64_linux_Release"
5.Copy shader.frag, shader.vert and lenaRGB.ppm from "$(ROOTDIR)\OpenCL\src\vulkanImageOpenCL\" to "$(ROOTDIR)\OpenCL\bin\x86_64_linux_Release"
6. Run simpleVulkan.exe and vulkanImageOpenCL.exe.