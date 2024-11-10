//{"float2":2,"size1":1,"size2":3,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void identity_deriv_assign(global float* vec1, uint4 size1, global float* float2, uint4 size2) {
  for (unsigned int i = get_global_id(0); i < size1.z; i += get_global_size(0)) {
    vec1[hook(0, i * size1.y + size1.x)] = 1;
  }
}