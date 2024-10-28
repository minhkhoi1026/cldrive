#include "macros.hpp"



#define IA 16807    			
#define IM 2147483647 			
#define AM (1.0f/IM) 			
#define IQ 127773 
#define IR 2836
#define NTAB 16
#define NDIV (1 + (IM - 1)/ NTAB)
#define EPS 1.2e-7
#define RMAX (1.0f - EPS)
#define GROUP_SIZE 64




 
float ran1(int idum, __local int *iv)
{
    int j;
    int k;
    int iy = 0;
    int tid = get_local_id(0) + get_local_id(1) * get_local_size(0);

    for(j = NTAB; j >=0; j--)			
    {
        k = idum / IQ;
        idum = IA * (idum - k * IQ) - IR * k;

        if(idum < 0)
            idum += IM;

        if(j < NTAB)
            iv[NTAB* tid + j] = idum;
    }
    iy = iv[NTAB* tid];

    k = idum / IQ;
    idum = IA * (idum - k * IQ) - IR * k;

    if(idum < 0)
        idum += IM;

    j = iy / NDIV;
    iy = iv[NTAB * tid + j];
    return (AM * iy);	
}



__kernel void noise_uniform(__global uchar4* inputImage, __global uchar4* outputImage, int factor)
{
	int pos = get_global_id(0) + get_global_id(1) * get_global_size(0);

	float4 temp = convert_float4(inputImage[pos]);

	
	float avg = (temp.x + temp.y + temp.z + temp.y) / 4;

	
	
	__local int iv[NTAB * GROUP_SIZE];  

	
	float dev = ran1(-avg, iv);
	dev = (dev - 0.55f) * factor;

	
	outputImage[pos] = convert_uchar4_sat(temp + (float4)(dev));

	
}
