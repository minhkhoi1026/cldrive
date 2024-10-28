//{"kSizeK":2,"kSizeM":0,"kSizeN":1,"mat_a":3,"mat_b":4,"mat_c":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm_reference(const int kSizeM, const int kSizeN, const int kSizeK, const global float* mat_a, const global float* mat_b, global float* mat_c) {
  const int row = get_global_id(0);
  const int col = get_global_id(1);

  float result = 0.0f;
  for (int k = 0; k < kSizeK; k++) {
    float mat_a_val = mat_a[hook(3, k * kSizeM + row)];
    float mat_b_val = mat_b[hook(4, k * kSizeN + col)];
    result += mat_a_val * mat_b_val;
  }

  mat_c[hook(5, col * kSizeM + row)] = result;
}