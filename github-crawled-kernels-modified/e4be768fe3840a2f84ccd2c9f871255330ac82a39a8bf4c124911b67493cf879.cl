//{"d_VectA":0,"d_VectB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectVectAddDPKernel(global double* d_VectA, global double* d_VectB, global double* output) {
  size_t id = get_global_id(0);
  output[hook(2, id)] = d_VectA[hook(0, id)] + d_VectB[hook(1, id)];
}