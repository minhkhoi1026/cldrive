
 

__kernel void VectorHypot(__global float4* fg4A, __global float4* fg4B, __global float4* fg4Hypot, unsigned int uiOffset, int iInnerLoopCount, unsigned int uiNumElements)
{
    
    size_t szGlobalOffset = get_global_id(0) + uiOffset;

    
    if (szGlobalOffset >= uiNumElements)
    {   
        return; 
    }

    
    float4 f4A = fg4A[szGlobalOffset];
    float4 f4B = fg4B[szGlobalOffset];
    float4 f4H = (float4)0.0f;
     
    
    for (int i = 0; i < iInnerLoopCount; i++)  
    {
        
        f4H.x = hypot (f4A.x, f4B.x);
        f4H.y = hypot (f4A.y, f4B.y);
        f4H.z = hypot (f4A.z, f4B.z);
        f4H.w = hypot (f4A.w, f4B.w);
    }
    
    
    fg4Hypot[szGlobalOffset] = f4H;
}
