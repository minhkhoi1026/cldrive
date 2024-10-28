//{"float2":4,"float3":7,"inc1":2,"inc2":6,"inc3":9,"size1":3,"start1":1,"start2":5,"start3":8,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void element_prod(global float* vec1, unsigned int start1, unsigned int inc1, unsigned int size1, global const float* float2, unsigned int start2, unsigned int inc2, global const float* float3, unsigned int start3, unsigned int inc3) {
  for (unsigned int i = get_global_id(0); i < size1; i += get_global_size(0))
    vec1[hook(0, i * inc1 + start1)] = float2[hook(4, i * inc2 + start2)] * float3[hook(7, i * inc3 + start3)];
}