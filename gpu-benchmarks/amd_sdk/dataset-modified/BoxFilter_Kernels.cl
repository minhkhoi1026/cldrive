#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}





__kernel void box_filter(__global uint4* inputImage, __global uchar4* outputImage, uint N)
{
	int x = get_global_id(0);
	int y = (1get_global_id);
	int width = get_global_size(0);
	int height = get_global_size(1);
	int k = (N - 1) / 2;

	if(x < k || y < k || x > width - k - 1 || y > height - k - 1)
	{	
		outputImage[hook(1, x + y * width)] = (uchar4)(0);
		return;
	}

	
	int4 filterSize = (int4)(N * N);
	
	int2 posA = (int2)(x - k, y - k);
	int2 posB = (int2)(x + k, y - k);
	int2 posC = (int2)(x + k, y + k);
	int2 posD = (int2)(x - k, y + k);

	int4 sumA = (int4)(0);
	int4 sumB = (int4)(0);
	int4 sumC = (int4)(0);
	int4 sumD = (int4)(0);
	
	
	posA.x -= 1;
	posA.y -= 1;
	posB.y -= 1;
	posD.x -= 1;

	if(posA.x >= 0 && posA.y >= 0)
	{
		sumA = convert_int4(inputImage[hook(0, posA.x + posA.y * width)]);
	}
	if(posB.x >= 0 && posB.y >= 0)
	{
		sumB = convert_int4(inputImage[hook(0, posB.x + posB.y * width)]);
	}
	if(posD.x >= 0 && posD.y >= 0)
	{
		sumD = convert_int4(inputImage[hook(0, posD.x + posD.y * width)]);
	}
	sumC = convert_int4(inputImage[hook(0, posC.x + posC.y * width)]);

	outputImage[hook(1, x + y * width)] = convert_uchar4((sumA + sumC - sumB - sumD) / filterSize);
			
}

__kernel void horizontalSAT0(__global uchar4* input,
							 __global uint4* output,
							 int i, int r, int width)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	int pos = x + y * width;

	
	
	

	int c = pow((float)r, (float)i);
	
	uint4 sum = 0;
	
	for(int j = 0; j < r; j++)
	{
		if((x - (j * c)) < 0)
		{
			output[hook(1, pos)] = sum;
			return;
		}

		sum += convert_uint4(input[hook(0, pos - (j * c))]);
	} 

	output[hook(1, pos)] = sum;
}

__kernel void horizontalSAT(__global uint4* input,
						    __global uint4* output,
							int i, int r, int width)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	int pos = x + y * width;

	int c = pow((float)r, (float)i);
	
	uint4 sum = 0;
	
	for(int j = 0; j < r; j++)
	{
		if(x - (j * c) < 0)
		{
			output[hook(1, pos)] = sum;
			return;
		}
		sum += input[hook(0, pos - (j * c))];
	} 

	output[hook(1, pos)] = sum;
}


__kernel void verticalSAT(__global uint4* input,
			              __global uint4* output,
			              int i, int r, int width)
{
	int x = get_global_id(0);
	int y = get_global_id(1);

	int c = pow((float)r, (float)i);
	
	uint4 sum = (uint4)(0);

	for(int j = 0; j < r; j++)
	{
		if(y - (j * c) < 0)
		{
			output[hook(1, x + y * width)] = sum;
			return;
		}

		sum += input[hook(0, x + width * (y - (j * c)))];
	}

	output[hook(1, x + y * width)] = sum;
}




#define GROUP_SIZE 256

__kernel void box_filter_horizontal(__global uchar4* inputImage, __global uchar4* outputImage, int filterWidth)
{
	int x = get_global_id(0);
    int y = get_global_id(1);

	int width = get_global_size(0);
	int height = get_global_size(1);
	
	int pos = x + y * width;
	int k = (filterWidth - 1)/2;

	
	if(x < k || x >= (width - k))
	{
		outputImage[hook(1, pos)] = (uchar4)(0);
		return;
	}

	int4 size = (int4)(filterWidth);

	int4 sum = 0;	
	
	for(int X = -k; X < k; X=X+2)
	{
		sum += convert_int4(inputImage[hook(0, pos + X)]);
		sum += convert_int4(inputImage[hook(0, pos + X + 1)]);
	}
	sum += convert_int4(inputImage[hook(0, pos + k)]);
	outputImage[hook(1, pos)] = convert_uchar4(sum / size);		
}


__kernel void box_filter_vertical(__global uchar4* inputImage, __global uchar4* outputImage, int filterWidth)
{
	int x = get_global_id(0);
    	int y = get_global_id(1);

	int width = get_global_size(0);
	int height = get_global_size(1);
	
	int pos = x + y * width;
	int k = (filterWidth - 1)/2;

	
	if(y < k || y >= (height - k))
	{
		outputImage[hook(1, pos)] = (uchar4)(0);
		return;
	}
 
	int4 size = (int4)(filterWidth);

	int4 sum = 0;	
	
	for(int Y = -k; Y < k; Y=Y+2)
	{
		sum += convert_int4(inputImage[hook(0, pos + Y * width)]);
		sum += convert_int4(inputImage[hook(0, pos + (Y + 1) * width)]);
	}
	sum += convert_int4(inputImage[hook(0, pos + k * width)]);
	outputImage[hook(1, pos)] = convert_uchar4(sum / size);		
}


__kernel void box_filter_horizontal_local(__global uchar4* inputImage, __global uchar4* outputImage, int filterWidth, __local uchar4 *lds)
{
	int x = get_global_id(0);
    	int y = get_global_id(1);

	int width = get_global_size(0);
	int height = get_global_size(1);
	
	int pos = x + y * width;
	int k = (filterWidth - 1)/2;


	int lid = get_local_id(0);
	int gidX = get_group_id(0);
	int gidY = get_group_id(1);

	int gSizeX = get_local_size(0);
	int gSizeY = get_local_size(1);

	int firstElement = gSizeX * gidX + width * gidY * gSizeY;

	
	if(lid < k)
	{
		lds[hook(3, lid)] = inputImage[hook(0, firstElement - k + lid)];
		lds[GROUP_SIZE + k + lid] = inputImage[hook(0, firstElement + lid + 256)];
	}

	
	lds[hook(3, lid + k)] = inputImage[hook(0, firstElement + lid)];	

	barrier(CLK_LOCAL_MEM_FENCE);

	
	if(x < k || x >= (width - k))
		return;

	int4 size = (int4)(filterWidth);

	int4 sum = 0;	
	
	for(int X = -k; X <= k; X++)
	{
		sum += convert_int4(lds[hook(3, lid + X + k)]);
	}
	outputImage[hook(1, pos)] = convert_uchar4(sum / size);		
}
