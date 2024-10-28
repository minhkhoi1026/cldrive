//{"factor":1,"float2":2,"result":3,"size":4,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_mul_add(global const float4* vec1, float factor, global const float4* float2, global float4* result, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size / 4; i += get_global_size(0))
    result[hook(3, i)] = vec1[hook(0, i)] * factor + float2[hook(2, i)];
}