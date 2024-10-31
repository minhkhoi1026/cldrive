
 
 __kernel void DotProduct (__global float* a, __global float* b, __global float* c, int iNumElements)
{
    
    int iGID = get_global_id(0);

    
    if (iGID >= iNumElements)
    {   
        return; 
    }

    
    int iInOffset = iGID << 2;
    c[iGID] = a[iInOffset] * b[iInOffset] 
               + a[iInOffset + 1] * b[iInOffset + 1]
               + a[iInOffset + 2] * b[iInOffset + 2]
               + a[iInOffset + 3] * b[iInOffset + 3];
}
