//{"column_indices":1,"elements":2,"result":4,"row_indices":0,"size":5,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const unsigned int* row_indices, global const uint8* column_indices, global const float8* elements, global const float* vector, global float* result, unsigned int size) {
  float dot_prod;
  unsigned int start, next_stop;
  uint8 col_idx;
  float8 tmp_vec;
  float8 tmp_entries;

  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    dot_prod = 0.0f;
    start = row_indices[hook(0, row)] / 8;
    next_stop = row_indices[hook(0, row + 1)] / 8;

    for (unsigned int i = start; i < next_stop; ++i) {
      col_idx = column_indices[hook(1, i)];

      tmp_entries = elements[hook(2, i)];
      tmp_vec.s0 = vector[hook(3, col_idx.s0)];
      tmp_vec.s1 = vector[hook(3, col_idx.s1)];
      tmp_vec.s2 = vector[hook(3, col_idx.s2)];
      tmp_vec.s3 = vector[hook(3, col_idx.s3)];
      tmp_vec.s4 = vector[hook(3, col_idx.s4)];
      tmp_vec.s5 = vector[hook(3, col_idx.s5)];
      tmp_vec.s6 = vector[hook(3, col_idx.s6)];
      tmp_vec.s7 = vector[hook(3, col_idx.s7)];

      dot_prod += dot(tmp_entries.lo, tmp_vec.lo);
      dot_prod += dot(tmp_entries.hi, tmp_vec.hi);
    }
    result[hook(4, row)] = dot_prod;
  }
}