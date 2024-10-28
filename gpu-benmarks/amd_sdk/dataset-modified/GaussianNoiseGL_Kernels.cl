#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



#define IA 16807    			
#define IM 2147483647 			
#define AM (1.0/IM) 			
#define IQ 127773
#define IR 2836
#define NTAB 4
#define NDIV (1 + (IM - 1)/ NTAB)
#define EPS 1.2e-7
#define RMAX (1.0 - EPS)
#define FACTOR 60			
#define GROUP_SIZE 64
#define PI 3.14

float ran1(int idum, __local int *iv);
float2 BoxMuller(float2 uniform);


__kernel void gaussian_transform(__global uchar4* inputImage, __write_only  image2d_t outputImage, int factor)
{
    
    int pos0 = get_global_id(0) + 2 * get_global_size(0) * get_global_id(1);
    int pos1 = get_global_id(0) + get_global_size(0) + 2 * get_global_size(0) * get_global_id(1);

    
    float4 texel0 = convert_float4(inputImage[hook(0, pos0)]);
    float4 texel1 = convert_float4(inputImage[hook(0, pos1)]);

    
    float avg0 = (texel0.x + texel0.y + texel0.z + texel0.w) / 4;
    float avg1 = (texel1.x + texel1.y + texel1.z + texel1.w) / 4;

    __local int iv0[NTAB * GROUP_SIZE];
    __local int iv1[NTAB * GROUP_SIZE];

    
    float dev0 = ran1(-avg0, iv0);
    float dev1 = ran1(-avg1, iv1);

    
    float2 gaussian = BoxMuller((float2)(dev0, dev1));

    float4 out0 = (texel0 + (float4)(gaussian.x * factor))/((float4)255);
    float4 out1 = (texel1 + (float4)(gaussian.y * factor))/((float4)255);

    int2 locate0 ,locate1;
    locate0.x = get_global_id(0);
    locate0.y = get_global_id(1);
    locate1.x = get_global_id(0) + get_global_size(0);
    locate1.y = get_global_id(1);


    write_imagef(outputImage, locate0,out0 );
    write_imagef(outputImage, locate1,out1 );


}

