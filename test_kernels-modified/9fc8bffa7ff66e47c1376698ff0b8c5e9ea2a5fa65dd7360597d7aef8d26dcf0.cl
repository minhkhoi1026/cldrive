//{"matrix":0,"result":2,"vector":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatVecMultUsingDotFn(global float4* matrix, global float4* vector, global float* result) {
  size_t i = get_group_id(0) * get_local_size(0) + get_local_id(0);
  result[hook(2, i)] = dot(matrix[hook(0, i)], vector[hook(1, 0)]);
}