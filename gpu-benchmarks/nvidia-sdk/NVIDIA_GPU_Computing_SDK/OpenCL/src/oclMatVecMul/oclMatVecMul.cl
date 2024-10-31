
 

 

__kernel void MatVecMulUncoalesced0(const __global float* M,
                                    const __global float* V,
                                    uint width, uint height,
                                    __global float* W)
{
    
    uint y = get_global_id(0);
    if (y < height) {
    
        
        const __global float* row = M + y * width;

        
        float dotProduct = 0;
        for (int x = 0; x < width; ++x)
            dotProduct += row[x] * V[x];

        
        W[y] = dotProduct;
    }
}


__kernel void MatVecMulUncoalesced1(const __global float* M,
                                    const __global float* V,
                                    uint width, uint height,
                                    __global float* W)
{        
    
    for (uint y = get_global_id(0);
         y < height;
         y += get_global_size(0))
    {

        
        const __global float* row = M + y * width;

        
        float dotProduct = 0;
        for (uint x = 0; x < width; ++x)
            dotProduct += row[x] * V[x];

        
        W[y] = dotProduct;
    }
}


__kernel void MatVecMulCoalesced0(const __global float* M,
                                  const __global float* V,
                                  uint width, uint height,
                                  __global float* W,
                                  __local float* partialDotProduct)
{    
    
    for (uint y = get_group_id(0); y < height; y += get_num_groups(0)) {

        
        const __global float* row = M + y * width;
        
        
        
        float sum = 0;
        for (uint x = get_local_id(0); x < width; x += get_local_size(0))
            sum += row[x] * V[x];

        
        partialDotProduct[get_local_id(0)] = sum;

        
        
        
        
        barrier(CLK_LOCAL_MEM_FENCE);

        
        
        if (get_local_id(0) == 0) {
            float dotProduct = 0;
            for (uint t = 0; t < get_local_size(0); ++t)
                dotProduct += partialDotProduct[t];
            W[y] = dotProduct;
	    }

        
        
        barrier(CLK_LOCAL_MEM_FENCE);
	}
}


__kernel void MatVecMulCoalesced1(const __global float* M,
                                  const __global float* V,
                                  uint width, uint height,
                                  __global float* W,
                                  __local float* partialDotProduct)
{    
    
    for (uint y = get_group_id(0); y < height; y += get_num_groups(0)) {

        
        const __global float* row = M + y * width;
        
        
        
        float sum = 0;
        for (uint x = get_local_id(0); x < width; x += get_local_size(0))
            sum += row[x] * V[x];

        
        partialDotProduct[get_local_id(0)] = sum;
        
        
        
        for (uint stride = 1; stride < get_local_size(0); stride *= 2) {

            
            
            
            barrier(CLK_LOCAL_MEM_FENCE);
            
            
            
            uint index = 2 * stride * get_local_id(0);
            
            
            if (index < get_local_size(0)) {
            
                
                
                partialDotProduct[index] += partialDotProduct[index + stride];
            }
        }

        
        if (get_local_id(0) == 0)
            W[y] = partialDotProduct[0];

        
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }
}


__kernel void MatVecMulCoalesced2(const __global float* M,
                                  const __global float* V,
                                  uint width, uint height,
                                  __global float* W,
                                  __local float* partialDotProduct)
{    
    
    for (uint y = get_group_id(0); y < height; y += get_num_groups(0)) {

        
        const __global float* row = M + y * width;
        
        
        
        float sum = 0;
        for (uint x = get_local_id(0); x < width; x += get_local_size(0))
            sum += row[x] * V[x];

        
        partialDotProduct[get_local_id(0)] = sum;
        
        
        
        for (uint stride = get_local_size(0) / 2; stride > 0; stride /= 2) {

            
            
            
            barrier(CLK_LOCAL_MEM_FENCE);
            
            
            if (get_local_id(0) < stride) {
            
                
                
                partialDotProduct[get_local_id(0)] += partialDotProduct[get_local_id(0) + stride];
            }
        }

        
        if (get_local_id(0) == 0)
            W[y] = partialDotProduct[0];

        
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }
}

#define WARP_SIZE 32
__kernel void MatVecMulCoalesced3(const __global float* M,
                                  const __global float* V,
                                  uint width, uint height,
                                  __global float* W,
                                  __local float* partialDotProduct)
{
   
   for (uint y = get_group_id(0); y < height; y += get_num_groups(0)) {
      const __global float* row = M + y * width;

      
      
      float sum = 0;
      for (uint x = get_local_id(0); x < width; x += get_local_size(0))
         sum += row[x] * V[x];

      
      partialDotProduct[get_local_id(0)] = sum;

      
      

      
      
      barrier(CLK_LOCAL_MEM_FENCE);

      
      uint id = get_local_id(0) & (WARP_SIZE - 1); 

      
      float warpResult = 0.0f;
      if (get_local_id(0) < get_local_size(0)/2 )
      {
          volatile __local float* p = partialDotProduct + 2 * get_local_id(0) - id;
          p[0] += p[32];
          p[0] += p[16];
          p[0] += p[8];
          p[0] += p[4];
          p[0] += p[2];
          p[0] += p[1];
          warpResult = p[0];
      }

      
      
      barrier(CLK_LOCAL_MEM_FENCE);

      
      
      if (id == 0)
         partialDotProduct[get_local_id(0) / WARP_SIZE] = warpResult;

      
      
      barrier(CLK_LOCAL_MEM_FENCE);

      
      uint size = get_local_size(0) / (2 * WARP_SIZE);

      
      
      
      if (get_local_id(0) < size / 2) {
         volatile __local float* p = partialDotProduct + get_local_id(0);
         if (size >= 8)
            p[0] += p[4];
         if (size >= 4)
            p[0] += p[2];
         if (size >= 2)
            p[0] += p[1];
      }

      
      if (get_local_id(0) == 0)
         W[y] = partialDotProduct[0];

      
      
      barrier(CLK_LOCAL_MEM_FENCE);
   }
}
