//{"fac":1,"float2":2,"result":3,"size":4,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul_add(global const float* vec1, global const float* fac, global const float* float2, global float* result, unsigned int size) {
  float factor = *fac;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    result[hook(3, i)] = vec1[hook(0, i)] * factor + float2[hook(2, i)];
}