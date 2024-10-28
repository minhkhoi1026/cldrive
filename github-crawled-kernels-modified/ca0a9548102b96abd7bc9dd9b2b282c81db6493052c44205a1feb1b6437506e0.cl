//{"d_MatA":0,"d_MatB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatMatAddKernelGMSP(global float* d_MatA, global float* d_MatB, global float* output) {
  size_t id = (get_global_id(1) * get_global_size(0) + get_global_id(0));
  output[hook(2, id)] = d_MatA[hook(0, id)] + d_MatB[hook(1, id)];
}