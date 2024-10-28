//{"a":1,"b":2,"out":3,"reductionDim":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_f64(unsigned int reductionDim, global double* a, global double* b, global double* out) {
  const unsigned int i = get_global_id(0);
  const unsigned int k = get_global_id(1);
  const unsigned int l = get_global_id(2);
  const unsigned int outerStrideB = get_global_size(1);
  const unsigned int innerStrideB = get_global_size(2);

  double accumulator = 0.0;
  for (unsigned int j = 0; j < reductionDim; ++j) {
    accumulator += a[hook(1, i * reductionDim + j)] * b[hook(2, (k * reductionDim + j) * innerStrideB + l)];
  }
  out[hook(3, (i * outerStrideB + k) * innerStrideB + l)] = accumulator;
}