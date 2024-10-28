//{"a":3,"expansionDim":0,"innerStride":1,"out":4,"repeats":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void repeat_f32(unsigned int expansionDim, unsigned int innerStride, unsigned int repeats, global float* restrict a, global float* restrict out) {
  const unsigned int i = get_global_id(0);
  const unsigned int j = get_global_id(1);
  const unsigned int k = get_global_id(2);
  const float value = a[hook(3, (i * expansionDim + j) * innerStride + k)];
  unsigned int offsetOut = (i * expansionDim + j) * repeats * innerStride + k;
  for (unsigned int c = 0; c < repeats; ++c) {
    out[hook(4, offsetOut)] = value;
    offsetOut += innerStride;
  }
}