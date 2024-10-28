//{"a_mat":0,"b_mat":1,"c_mat":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mult(global float4* a_mat, global float4* b_mat, global float* c_mat) {
  float sum;
  int num_rows = get_global_size(0);
  int vectors_per_row = num_rows / 4;
  int start = get_global_id(0) * vectors_per_row;
  a_mat += start;
  c_mat += start * 4;
  for (int i = 0; i < num_rows; i++) {
    sum = 0.0f;
    for (int j = 0; j < vectors_per_row; j++)
      sum += dot(a_mat[hook(0, j)], b_mat[hook(1, i * vectors_per_row + j)]);
    c_mat[hook(2, i)] = sum;
  }
}