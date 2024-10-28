//{"m1":0,"m2":1,"res":2,"wm1":3,"wm2":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_matrix(global float* m1, global float* m2, global float* res, unsigned long int wm1, unsigned long int wm2) {
  unsigned long int i = get_group_id(0);
  unsigned long int j = get_local_id(0);
  unsigned long int k;
  float sum = 0.0f;
  for (k = 0; k < wm1; ++k)
    sum += m1[hook(0, i * wm1 + k)] * m2[hook(1, k * wm2 + j)];
  res[hook(2, i * wm2 + j)] = sum;
}