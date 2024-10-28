//{"fac":2,"float2":1,"size":3,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inplace_mul_add(global float4* vec1, global const float4* float2, global const float* fac, unsigned int size) {
  float factor = *fac;
  unsigned int size_div_4 = size >> 2;
  for (unsigned int i = get_global_id(0); i < size_div_4; i += get_global_size(0))
    vec1[hook(0, i)] += float2[hook(1, i)] * factor;
}