//{"output":2,"src":1,"wSrc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_tanh(const int wSrc, global const float* src, global float* output) {
  const int idx = get_global_id(0);
  const int idy = get_global_id(1);

  output[hook(2, idy * wSrc + idx)] = tanh(src[hook(1, idy * wSrc + idx)]);
}