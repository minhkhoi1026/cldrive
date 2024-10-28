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
  float4 lhs;
  float4 rhs;
  for (int i = 0; i < width_A; i += 4) {
    lhs = (float4)(A[hook(0, y * width_A + i + 0)], A[hook(0, y * width_A + i + 1)], A[hook(0, y * width_A + i + 2)], A[hook(0, y * width_A + i + 3)]);
    rhs = (float4)(B[hook(1, i * width_B + x)], B[hook(1, (i + 1) * width_B + x)], B[hook(1, (i + 2) * width_B + x)], B[hook(1, (i + 3) * width_B + x)]);
    result += dot(lhs, rhs);
  }

  C[hook(2, y * width_B + x)] = result;
}