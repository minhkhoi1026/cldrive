

#ifndef BOX_FILTER_GL_SAT_H_
#define BOX_FILTER_GL_SAT_H_

#include "CommonDeclare.hpp"


#ifndef INPUT_IMAGE
#define INPUT_IMAGE "BoxFilterGL_Input.bmp"
#endif
#define OUTPUT_SAT_IMAGE "BoxFilterGLSAT_Output.bmp"

#define GROUP_SIZE 256     
#define FILTER 9          
#define SAT_FETCHES 16     

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif


#define screenWidth  512
#define screenHeight 512

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"



class BoxFilterGLSAT
{
    public:

        static BoxFilterGLSAT *boxFilterGLSAT;
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_double satHorizontalTime;        
        cl_double satVerticalTime;          
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem tempImageBuffer0;
        cl_mem tempImageBuffer1;
        cl_mem outputImageBuffer;           
        cl_uchar4*
        verificationOutput;       
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;                   
        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        cl_bool byteRWSupport;
        size_t kernelWorkGroupSize;         
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        cl_uint n;                          
        cl_uint m;                          
        cl_mem *satHorizontalBuffer;        
        cl_mem *satVerticalBuffer;          
        cl_uint rHorizontal;                
        cl_uint rVertical;                  
        cl_kernel horizontalSAT0;           
        cl_kernel horizontalSAT;            
        cl_kernel verticalSAT;              
        SDKDeviceInfo deviceInfo;        
        KernelWorkGroupInfo kernelInfo,kernelInfoHSAT0,kernelInfoHSAT,
                            kernelInfoVSAT;        

        clock_t t1, t2;
        int frameCount;
        int frameRefCount;
        double totalElapsedTime;
        GLuint pbo;                         
        GLuint tex;                         
        cl_device_id interopDeviceId;
		bool dummy_sep_variable;
		bool dummy_sat_variable;
        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        BoxFilterGLSAT()
            :inputImageData(NULL),
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
            rHorizontal = SAT_FETCHES;
            rVertical = SAT_FETCHES;
            satHorizontalBuffer = NULL;
            satVerticalBuffer = NULL;

            frameCount = 0;
            frameRefCount = 90;
            totalElapsedTime = 0.0;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        ~BoxFilterGLSAT()
        {
        }

        
        int setupBoxFilter();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        int runSatKernel(cl_kernel kernel,
                         cl_mem *input,
                         cl_mem *output,
                         cl_uint pass,
                         cl_uint r);

        int runBoxFilterKernel();

        
        void boxFilterCPUReference();

        
        void printStats();

        
        int initializeGLAndGetCLContext(cl_platform_id platform,
                                        cl_context &context,
                                        cl_device_id &interopDevice);

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

#ifdef _WIN32
        
        int enableGLAndGetGLContext(HWND hWnd,
                                    HDC &hDC,
                                    HGLRC &hRC,
                                    cl_platform_id platform,
                                    cl_context &context,
                                    cl_device_id &interopDevice);

        void disableGL(HWND hWnd, HDC hDC, HGLRC hRC);
#endif
};

#endif 
