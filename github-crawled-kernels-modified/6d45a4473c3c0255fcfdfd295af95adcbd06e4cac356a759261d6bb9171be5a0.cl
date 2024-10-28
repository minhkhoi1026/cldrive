//{"m1":1,"m1_width":3,"m2":2,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotProd(global float* result, global float* m1, global float* m2, unsigned int m1_width) {
  int m1_height = get_global_size(0);
  int m2_width = get_global_size(1);
  int i = get_global_id(0);
  int j = get_global_id(1);

  int k;
  float temp_r = 0.0f;
  for (k = 0; k < m1_width; k++) {
    temp_r += m1[hook(1, i * m1_width + k)] * m2[hook(2, j + k * m2_width)];
  }
  result[hook(0, i * m2_width + j)] = temp_r;
}