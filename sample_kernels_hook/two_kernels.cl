int hook(int argId, int id) {
    int gid = get_global_id(0);
    printf("%d,%d,%d\n",gid, argId, id);
    return id;
}

kernel void summation(global float* in, global float* out, int N, int k, int c)              
{
    int id = get_global_id(0) + c;
    
    float sum = 0.0f;
    
    // process k elements sequentially
    for (int i = 0; i < k; i++) {
        // current element index of in array
        int cId = id * k + i;
        
        if (cId < N) {            
            sum += in[hook(0, cId)];
        }
    }
    
    out[hook(1, id)] = sum;
}

kernel void convolution(global float* in, global float* out, int os, int st) {
 int id = get_global_id(0)*st+os;
 out[hook(1, id)] = in[hook(0, id - 1)] * 0.5f + in[hook(0, id)] * 1.0f + in[hook(0, id + 1)] * 0.5f ;
}
