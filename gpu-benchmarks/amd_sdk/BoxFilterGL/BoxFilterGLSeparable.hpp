

#ifndef BOX_FILTER_GL_SEPARABLE_H_
#define BOX_FILTER_GL_SEPARABLE_H_
#include "CommonDeclare.hpp"
#ifndef INPUT_IMAGE
#define INPUT_IMAGE "BoxFilterGL_Input.bmp"
#endif
#define OUTPUT_SEPARABLE_IMAGE "BoxFilterGLSeparable_Output.bmp"

#define GROUP_SIZE 256
#define FILTER_WIDTH 9



class BoxFilterGLSeparable
{
    public:
        static BoxFilterGLSeparable *boxFilterGLSeparable;
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem tempImageBuffer;
        cl_mem outputImageBuffer;           
        cl_uchar4*
        verificationOutput;       
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel horizontalKernel;         
        cl_kernel verticalKernel;           
        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        cl_bool byteRWSupport;
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        int filterWidth;                    
        clock_t t1, t2;
        int frameCount;
        int frameRefCount;
        double totalElapsedTime;
        GLuint pbo;                         
        GLuint tex;                         
        cl_device_id interopDeviceId;
        SDKDeviceInfo
        deviceInfo;                         
        KernelWorkGroupInfo kernelInfoH,
                            kernelInfoV;     
		bool dummy_sep_variable;
		bool dummy_sat_variable;
        SDKTimer    *sampleTimer;            

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        BoxFilterGLSeparable()
            : inputImageData(NULL),
              outputImageData(NULL),
              verificationOutput(NULL),
              byteRWSupport(true),
			  dummy_sep_variable(false),
			  dummy_sat_variable(false)
        {
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            filterWidth = FILTER_WIDTH;
            frameCount = 0;
            frameRefCount = 90;
            totalElapsedTime = 0.0;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
        }


        ~BoxFilterGLSeparable()
        {
        }

        
        int setupBoxFilter();

        
        int genBinaryImage();

        
        int setupCL();

        
        int initializeGLAndGetCLContext(cl_platform_id platform,
                                        cl_context &context,
                                        cl_device_id &interopDevice);

#ifdef _WIN32
        
        int enableGLAndGetGLContext(HWND hWnd,
                                    HDC &hDC,
                                    HGLRC &hRC,
                                    cl_platform_id platform,
                                    cl_context &context,
                                    cl_device_id &interopDevice);

        void disableGL(HWND hWnd, HDC hDC, HGLRC hRC);
#else

#endif
        
        int runCLKernels();

        
        void boxFilterCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 
