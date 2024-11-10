//{"matrix":0,"result":2,"vector":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_dot_vector(global const float4* matrix, global const float4* vector, global float* result) {
  int gid = get_global_id(0);
  result[hook(2, gid)] = dot(matrix[hook(0, gid)], vector[hook(1, 0)]);
}