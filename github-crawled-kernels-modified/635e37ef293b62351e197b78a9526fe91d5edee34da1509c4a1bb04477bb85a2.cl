//{"A":0,"B":1,"C":2,"width_A":3,"width_B":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mul(global float* A, global float* B, global float* C, int width_A, int width_B) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float result = 0;
  for (int i = 0; i < width_A; i++) {
    result += 1;
  }

  C[hook(2, y * width_B + x)] = result;
}