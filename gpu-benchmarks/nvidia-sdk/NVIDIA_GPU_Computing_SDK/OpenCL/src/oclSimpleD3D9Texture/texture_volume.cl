


__kernel void cl_kernel_texture_volume(
				__global uint *bufOut, 
				uint width, 
				uint height, 
				uint depth, 
				uint pitch, 
				uint pitchSlice )
{
    const int tx = get_local_id(0);		
    const int ty = get_local_id(1);		
    const int bw = get_local_size(0);	
    const int bh = get_local_size(1);	
    const int x = get_global_id(0);		
    const int y = get_global_id(1);		

    
    
    
    if (x >= width || y >= height) return;
    
    
    
	float4 pixel;
    for (int z = 0; z < depth; ++z)
    {
		
		pixel.x = (float)x / (float)(width - 1);
		pixel.y = (float)y / (float)(height - 1);
		pixel.z = (float)z / (float)(depth - 1);
		pixel.w = 1.0;

		pixel *= 255.0;
		uint res = (((uchar)pixel.w)<<24) 
			  | (((uchar)pixel.z)<<16) 
			  | (((uchar)pixel.y)<<8) 
			  | ((uchar)pixel.x);
		bufOut[x + y*pitch + z*pitchSlice] = res;
    }
}

