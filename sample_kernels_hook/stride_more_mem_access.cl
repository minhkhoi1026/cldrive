//{"in":0,"os":2,"out":1,"st":3}
int hook(int argId, int id) {
    int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution_more_mem_access(global float* in, global float* out, int os, int st) {
    int id = get_global_id(0) + os;
    float sum = 0.0f;
    for (int i = id * st; i < (id+1000)*st ; i += st) {
        sum += in[hook(0, i)];
    }
    out[hook(1, id)] = sum;
}
