//{"column_indices":1,"diag_M_inv":3,"elements":2,"row_indices":0,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void row_scaling_2(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* diag_M_inv, unsigned int size) {
  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    float dot_prod = 0.0f;
    float temp = 0.0f;
    unsigned int row_end = row_indices[hook(0, row + 1)];
    for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i) {
      temp = elements[hook(2, i)];
      dot_prod += temp * temp;
    }
    diag_M_inv[hook(3, row)] = 1.0f / sqrt(dot_prod);
  }
}