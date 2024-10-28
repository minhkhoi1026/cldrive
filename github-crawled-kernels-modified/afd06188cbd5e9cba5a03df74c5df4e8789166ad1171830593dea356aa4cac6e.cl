//{"in":1,"out":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void msquare(global float* out, global float* in, unsigned int size) {
  size_t i = get_global_id(0), j = get_global_id(1), id = i * size + j;

  out[hook(0, id)] = 0;
  for (unsigned int k = 0; k < size; ++k)
    out[hook(0, id)] += in[hook(1, i * size + k)] * in[hook(1, k * size + j)];
}