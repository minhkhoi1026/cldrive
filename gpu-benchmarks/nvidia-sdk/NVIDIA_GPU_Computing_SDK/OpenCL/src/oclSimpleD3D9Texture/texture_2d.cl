

#define PI 3.1415926536f


__kernel void cl_kernel_texture_2d(
#ifdef USE_STAGING_BUFFER
				__global uint *bufOut, 
#else
				__write_only image2d_t texOut, 
#endif
				__read_only image2d_t texIn, 
				uint width, 
				uint height, 
				uint pitch, 
				float t)
{
    const int tx = get_local_id(0);		
    const int ty = get_local_id(1);		
    const int bw = get_local_size(0);	
    const int bh = get_local_size(1);	
    const int x = get_global_id(0);		
    const int y = get_global_id(1);		

    
    
    
	if (x >= width || y >= height) return;

    
    
    
    float4 pixel = (float4)0;
    float4 color;
	
    int2 coord = (int2)(x, y); 
    const sampler_t smp = CLK_FILTER_NEAREST; 
	pixel = read_imagef(texIn, smp, coord); 
	
	float value_x = 0.5f + 0.5f*cos(t + 10.0f*( (2.0f*x)/width  - 1.0f ) );
	float value_y = 0.5f + 0.5f*cos(t + 10.0f*( (2.0f*y)/height - 1.0f ) );
#if 0 
	color = pixel;
#else
	color.x = 0.9*pixel.x + 0.1*pow(value_x, 3.0f);
	color.y = 0.9*pixel.y + 0.1*pow(value_y, 3.0f);
	color.z = 0.5f + 0.5f*cos(t);
	color.w = 1.0f;
#endif
#ifdef USE_STAGING_BUFFER
	color *= 255.0;
	uint value = (((uchar)color.w)<<24) 
		  | (((uchar)color.z)<<16) 
		  | (((uchar)color.y)<<8) 
		  | ((uchar)color.x);
	bufOut[x + y*pitch] = value;
#else
    write_imagef(texOut, coord, color); 
#endif
}

