//{"m1":1,"m2":2,"q":3,"r":4,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotProd2(global float* result, global float* m1, global float* m2, unsigned int q, unsigned int r) {
  int p = get_global_size(0);
  int i = get_global_id(0);

  int k;
  float temp_r;

  for (int j = 0; j < r; j++) {
    temp_r = 0.0f;
    for (k = 0; k < q; k++) {
      temp_r += m1[hook(1, i * q + k)] * m2[hook(2, j + k * r)];
    }
    result[hook(0, i * r + j)] = temp_r;
  }
}