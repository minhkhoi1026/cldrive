//{"matrix1":0,"matrix2":1,"result":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub_wise(global const float* matrix1, global const float* matrix2, global float* result, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    result[hook(2, i)] = matrix1[hook(0, i)] - matrix2[hook(1, i)];
}