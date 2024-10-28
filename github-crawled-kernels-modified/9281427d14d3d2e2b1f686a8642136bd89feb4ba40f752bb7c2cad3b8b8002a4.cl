//{"in":1,"lda":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_kernel(const int lda, global float* in, global float* out) {
  const unsigned int i = get_global_id(0);
  const unsigned int j = get_global_id(1);
  out[hook(2, j * lda + i)] = in[hook(1, i * lda + j)];
}