//{"a":1,"out":2,"reductionDim":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amin_f32(unsigned int reductionDim, global float* a, global float* out) {
  const unsigned int innerStride = get_global_size(1);
  const unsigned int i = get_global_id(0);
  const unsigned int k = get_global_id(1);
  a += i * reductionDim * innerStride + k;
  float accumulator = *a;
  while (--reductionDim) {
    a += innerStride;
    accumulator = min(accumulator, *a);
  }
  out[hook(2, i * innerStride + k)] = accumulator;
}