


#include <oclUtils.h>



#define CLAMP_TO_EDGE


#define USE_SIMPLE_FILTER 0


typedef struct _GaussParms
{
    float nsigma; 
    float alpha;
    float ema; 
    float ema2; 
    float b1; 
    float b2; 
    float a0; 
    float a1; 
    float a2; 
    float a3; 
    float coefp; 
    float coefn; 
} GaussParms, *pGaussParms;


static GaussParms oclGP;               


extern "C" void PreProcessGaussParms (float fSigma, int iOrder, GaussParms* pGP);


extern "C" double HostRecursiveGaussianRGBA(unsigned int* uiInputImage, unsigned int* uiTempImage, unsigned int* uiOutputImage, 
                                          int iWidth, int iHeight, GaussParms* pGP);
