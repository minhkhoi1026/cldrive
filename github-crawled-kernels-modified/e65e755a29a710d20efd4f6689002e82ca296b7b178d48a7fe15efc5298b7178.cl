//{"A_mem":2,"A_width":0,"B_mem":3,"B_width":1,"C_mem":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GEMM(const int A_width, const int B_width, const global float* A_mem, const global float* B_mem, global float* C_mem) {
  const int row = get_global_id(0);
  const int col = get_global_id(1);

  float acc = 0.0f;
  for (int e = 0; e < A_width; e++)
    acc += A_mem[hook(2, row * A_width + e)] * B_mem[hook(3, e * B_width + col)];

  C_mem[hook(4, row * B_width + col)] = acc;
}