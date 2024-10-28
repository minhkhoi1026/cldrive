//{"matrix_3":2,"placeholder0":0,"placeholder1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void default_function(global int* restrict placeholder0, global int* restrict placeholder1, global int* restrict matrix_3) {
  for (int x = 0; x < 10; ++x) {
    for (int y = 0; y < 10; ++y) {
      int sum;
      sum = 0;
      for (int k = 0; k < 10; ++k) {
        sum = ((int)(((int64_t)(((long)placeholder0[(k + (x * 10))]) * ((long)placeholder1[(y + (k * 10))]))) + ((int64_t)sum)));
      }
      matrix_3[hook(2, (y + (x * 10)))] = sum;
    }
  }
}