



float4 rgbaUintToFloat4(const unsigned int uiPackedRGBA)
{
    float4 rgba;
    rgba.x = uiPackedRGBA & 0xff;
    rgba.y = (uiPackedRGBA >> 8) & 0xff;
    rgba.z = (uiPackedRGBA >> 16) & 0xff;
    rgba.w = (uiPackedRGBA >> 24) & 0xff;
    return rgba;
}



unsigned int rgbaFloat4ToUint(const float4 rgba)
{
    unsigned int uiPackedRGBA = 0U;
    uiPackedRGBA |= 0x000000FF & (unsigned int)rgba.x;
    uiPackedRGBA |= 0x0000FF00 & (((unsigned int)rgba.y) << 8);
    uiPackedRGBA |= 0x00FF0000 & (((unsigned int)rgba.z) << 16);
    uiPackedRGBA |= 0xFF000000 & (((unsigned int)rgba.w) << 24);
    return uiPackedRGBA;
}



__kernel void Transpose(__global const unsigned int* uiDataIn, __global unsigned int* uiDataOut, 
                        int iWidth, int iHeight, 
                        __local unsigned int* uiLocalBuff)
{
    
    unsigned int xIndex = get_global_id(0);
    unsigned int yIndex = get_global_id(1);

    if((xIndex < iWidth) && (yIndex < iHeight))
    {
        uiLocalBuff[get_local_id(1) * (get_local_size(0) + 1) + get_local_id(0)] = uiDataIn[(yIndex * iWidth) + xIndex];
    }

    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    xIndex = mul24(get_group_id(1), get_local_size(1)) + get_local_id(0);
    yIndex = mul24(get_group_id(0), get_local_size(0)) + get_local_id(1);
    if((xIndex < iHeight) && (yIndex < iWidth))
    {
        uiDataOut[(yIndex * iHeight) + xIndex] = uiLocalBuff[get_local_id(0) * (get_local_size(1) + 1) + get_local_id(1)];
    }
}











__kernel void SimpleRecursiveRGBA(__global const unsigned int* uiDataIn, __global unsigned int* uiDataOut, 
                                  int iWidth, int iHeight, float a)
{
    
    unsigned int X = mul24(get_group_id(0), get_local_size(0)) + get_local_id(0);
	if (X >= iWidth) return;
    
    
    uiDataIn += X;    
    uiDataOut += X;

    
    float4 yp = rgbaUintToFloat4(*uiDataIn);  
    for (int Y = 0; Y < iHeight; Y++) 
    {
        float4 xc = rgbaUintToFloat4(*uiDataIn);
        float4 yc = xc + (yp - xc) * (float4)a;   
		*uiDataOut = rgbaFloat4ToUint(yc);
        yp = yc;
        uiDataIn += iWidth;     
        uiDataOut += iWidth;    
    }

    
    uiDataIn -= iWidth;
    uiDataOut -= iWidth;

    
    yp = rgbaUintToFloat4(*uiDataIn);
    for (int Y = iHeight - 1; Y > -1; Y--) 
    {
        float4 xc = rgbaUintToFloat4(*uiDataIn);
        float4 yc = xc + (yp - xc) * (float4)a;
		*uiDataOut = rgbaFloat4ToUint((rgbaUintToFloat4(*uiDataOut) + yc) * 0.5f);
        yp = yc;
        uiDataIn -= iWidth;   
        uiDataOut -= iWidth;  
    }
}












__kernel void RecursiveGaussianRGBA(__global const unsigned int* uiDataIn, __global unsigned int* uiDataOut, 
                                    int iWidth, int iHeight, 
                                    float a0, float a1, 
                                    float a2, float a3, 
                                    float b1, float b2, 
                                    float coefp, float coefn)
{
    
    unsigned int X = mul24(get_group_id(0), get_local_size(0)) + get_local_id(0);
	if (X >= iWidth) return;

    
    uiDataIn += X;    
    uiDataOut += X;

    
    float4 xp = (float4)0.0f;  
    float4 yp = (float4)0.0f;  
    float4 yb = (float4)0.0f;  

#ifdef CLAMP_TO_EDGE
    xp = rgbaUintToFloat4(*uiDataIn); 
    yb = xp * (float4)coefp; 
    yp = yb;
#endif

    for (int Y = 0; Y < iHeight; Y++) 
    {
        float4 xc = rgbaUintToFloat4(*uiDataIn);
        float4 yc = (xc * a0) + (xp * a1) - (yp * b1) - (yb * b2);
		*uiDataOut = rgbaFloat4ToUint(yc);
        xp = xc; 
        yb = yp; 
        yp = yc; 
        uiDataIn += iWidth;     
        uiDataOut += iWidth;    
    }

    
    uiDataIn -= iWidth;
    uiDataOut -= iWidth;

    
    float4 xn = (float4)0.0f;
    float4 xa = (float4)0.0f;
    float4 yn = (float4)0.0f;
    float4 ya = (float4)0.0f;

#ifdef CLAMP_TO_EDGE
    xn = rgbaUintToFloat4(*uiDataIn);
    xa = xn; 
    yn = xn * (float4)coefn; 
    ya = yn;
#endif

    for (int Y = iHeight - 1; Y > -1; Y--) 
    {
        float4 xc = rgbaUintToFloat4(*uiDataIn);
        float4 yc = (xn * a2) + (xa * a3) - (yn * b1) - (ya * b2);
        xa = xn; 
        xn = xc; 
        ya = yn; 
        yn = yc;
		*uiDataOut = rgbaFloat4ToUint(rgbaUintToFloat4(*uiDataOut) + yc);
        uiDataIn -= iWidth;   
        uiDataOut -= iWidth;  
    }
}
