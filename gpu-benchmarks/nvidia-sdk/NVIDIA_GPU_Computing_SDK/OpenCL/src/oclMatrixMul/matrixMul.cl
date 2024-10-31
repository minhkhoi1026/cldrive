



#define AS(i, j) As[j + i * BLOCK_SIZE]
#define BS(i, j) Bs[j + i * BLOCK_SIZE]





__kernel void
matrixMul( __global float* C, __global float* A, __global float* B, 
	   __local float* As, __local float* Bs, int uiWA, int uiWB, int trueLocalSize1)
{
    
    int bx = get_group_id(0);
    int by = get_group_id(1);

    
    int tx = get_local_id(0);
    int ty = get_local_id(1);

    
    int aBegin = uiWA * BLOCK_SIZE * by;

    
    int aEnd   = aBegin + uiWA - 1;

    
    int aStep  = BLOCK_SIZE;

    
    int bBegin = BLOCK_SIZE * bx;

    
    int bStep  = BLOCK_SIZE * uiWB;

    
    
    float Csub = 0.0f;

    
    
    for (int a = aBegin, b = bBegin;
             a <= aEnd;
             a += aStep, b += bStep) {

        
        
        
        AS(ty, tx) = A[a + uiWA * ty + tx];
        BS(ty, tx) = B[b + uiWB * ty + tx];
	
        
        barrier(CLK_LOCAL_MEM_FENCE);

        
        
        
        #pragma unroll
        for (int k = 0; k < BLOCK_SIZE; ++k)
            Csub += AS(ty, k) * BS(k, tx);

        
        
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    if (get_global_id(1) < trueLocalSize1)
    
    
    C[get_global_id(1) * get_global_size(0) + get_global_id(0)] = Csub;

}

