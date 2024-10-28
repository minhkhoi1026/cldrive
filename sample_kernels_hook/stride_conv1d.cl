// //{"in":0,"os":2,"out":1,"st":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n",  gID, argId, id);
	return id;
}
kernel void convolution(global float* in, global float* out, int os, int st) {
 int id = get_global_id(0)*st+os;
 out[hook(1, id)] = in[hook(0, id - 1)] * 0.5f + in[hook(0, id)] * 1.0f + in[hook(0, id + 1)] * 0.5f ;
}


