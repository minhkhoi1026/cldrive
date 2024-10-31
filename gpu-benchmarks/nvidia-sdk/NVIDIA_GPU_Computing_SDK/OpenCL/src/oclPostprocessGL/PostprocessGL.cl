

#define USE_LOCAL_MEM


#define SMEM(X, Y) sdata[(Y)*tilew+(X)]

int iclamp(int x, int a, int b)
{
    return max(a, min(b, x));
}


uint rgbToInt(float r, float g, float b)
{
  r = clamp(r, 0.0f, 255.0f);
  g = clamp(g, 0.0f, 255.0f);
  b = clamp(b, 0.0f, 255.0f);
  return (convert_uint(b)<<16) + (convert_uint(g)<<8) + convert_uint(r);
}


uint getPixel(__global uint *data, int x, int y, int width, int height)
{
    x = iclamp(x, 0, width - 1);
    y = iclamp(y, 0, height - 1);
    return data[y * width + x];
}



__kernel void postprocess(__global uint* g_data, __global uint* g_odata, int imgw, int imgh, int tilew, int radius, float threshold, float highlight, __local uint* sdata)
{
    const int tx = get_local_id(0);
    const int ty = get_local_id(1);
    const int bw = get_local_size(0);
    const int bh = get_local_size(1);
    const int x = get_global_id(0);
    const int y = get_global_id(1);

    if( x >= imgw || y >= imgh ) return;

#ifdef USE_LOCAL_MEM   
    
    
    SMEM(radius + tx, radius + ty) = getPixel(g_data, x, y, imgw, imgh);

    
    if (tx < radius) {
        
        SMEM(tx, radius + ty) = getPixel(g_data, x - radius, y, imgw, imgh);
        
        SMEM(radius + bw + tx, radius + ty) = getPixel(g_data, x + bw, y, imgw, imgh);
    }
    if (ty < radius) {
        
        SMEM(radius + tx, ty) = getPixel(g_data, x, y - radius, imgw, imgh);
        
        SMEM(radius + tx, radius + bh + ty) = getPixel(g_data, x, y + bh, imgw, imgh);
    }

    
    if ((tx < radius) && (ty < radius)) {
        
        SMEM(tx, ty) = getPixel(g_data, x - radius, y - radius, imgw, imgh);
        
        SMEM(tx, radius + bh + ty) = getPixel(g_data, x - radius, y + bh, imgw, imgh);
        
        SMEM(radius + bw + tx, ty) = getPixel(g_data, x + bh, y - radius, imgw, imgh);
        
        SMEM(radius + bw + tx, radius + bh + ty) = getPixel(g_data, x + bw, y + bh, imgw, imgh);
    }

    
    barrier(CLK_LOCAL_MEM_FENCE);
#endif

    
    float rsum = 0.0f;
    float gsum = 0.0f;
    float bsum = 0.0f;
    float samples = 0.0f;
     
    for(int dy=-radius; dy<=radius; dy++) 
    {
        for(int dx=-radius; dx<=radius; dx++) 
        {

#ifdef USE_LOCAL_MEM
	        uint pixel = SMEM(radius + tx + dx, radius + ty + dy);
#else
	        uint pixel = getPixel(g_data, x + dx, y + dy, imgw, imgh);
#endif
	 
            
            float l = dx*dx + dy*dy;
	        if (l <= radius*radius) 
            {
                float r = convert_float(pixel&0x0ff);
                float g = convert_float((pixel>>8)&0x0ff);
                float b = convert_float((pixel>>16)&0x0ff);

                
                float lum = (r + g + b) * 0.001307189542f;
                if (lum > threshold) 
                {
                    r *= highlight;
                    g *= highlight;
	                b *= highlight;
                }

	            rsum += r;
	            gsum += g;
	            bsum += b;
	            samples += 1.0f;
            }
        }
    }

    rsum /= samples;
    gsum /= samples;
    bsum /= samples;

    g_odata[y * imgw + x] = rgbToInt(rsum, gsum, bsum);
}

