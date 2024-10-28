//{"A":0,"B":1,"C":2,"height_B":4,"width_A":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mul(global float* A, global float* B, global float* C, const int width_A, const int height_B) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float result = 0;
  for (int i = 0; i < width_A; i++) {
    result += A[hook(0, y * width_A + i)] * B[hook(1, x * width_A + i)];
  }

  C[hook(2, y * height_B + x)] = result;
}