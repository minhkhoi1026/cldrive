int hook(int argId, int id) {
    int gid = get_global_id(0);
    printf("%d,%d,%d\n",gid, argId, id);
    return id;
}
kernel void summation(global float* in, global float* out, int N, int k)              
{
    int id = get_global_id(0);
    
    float sum = 0.0f;
    
    
    for (int i = 0; i < k; i++) {
        
        int cId = id * k + i;
        
        if (cId < N) {            
            sum += in[hook(0, cId)];
        }
    }
    
    out[hook(1, id)] = sum;
}