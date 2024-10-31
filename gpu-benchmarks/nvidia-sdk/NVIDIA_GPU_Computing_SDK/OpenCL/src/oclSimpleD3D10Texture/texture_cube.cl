

#define PI 3.1415926536f


__kernel void cl_kernel_texture_cube(
#ifdef USE_STAGING_BUFFER
				__global uint *bufOut, 
#else
				__write_only image2d_t texOut, 
#endif
				uint size, 
				uint pitch, 
				int face, 
				float t)
{
    const int tx = get_local_id(0);		
    const int ty = get_local_id(1);		
    const int bw = get_local_size(0);	
    const int bh = get_local_size(1);	
    const int x = get_global_id(0);		
    const int y = get_global_id(1);		

    
    
    
	if (x >= size || y >= size) return;
	
	
	float theta_x = (2.0f*(float)x)/(float)pitch  - 1.0f;
	float theta_y = (2.0f*(float)y)/(float)size - 1.0f;
	float theta = 2.0f*PI*sqrt(theta_x*theta_x + theta_y*theta_y);
	float value = ( 0.6f + 0.4f*cos(theta + t) );
	
    float4 color;
	color.w = 1.0;
	if (face < 3)
	{
		color.x = face == 0 ? value : 0.0;
		color.y = face == 1 ? value : 0.0;
		color.z = face == 2 ? value : 0.0;
	}
	else
	{
		color.x = face == 3 ? value : 0.5;
		color.y = face == 4 ? value : 0.5;
		color.z = face == 5 ? value : 0.5;
	}
#ifdef USE_STAGING_BUFFER
	color *= 255.0;
	uint res = (((uchar)color.w)<<24) 
		  | (((uchar)color.z)<<16) 
		  | (((uchar)color.y)<<8) 
		  | ((uchar)color.x);
	bufOut[x + y*pitch] = res;
#else
    int2 coord = (int2)(x, y); 
    write_imagef(texOut, coord, color); 
#endif
}

