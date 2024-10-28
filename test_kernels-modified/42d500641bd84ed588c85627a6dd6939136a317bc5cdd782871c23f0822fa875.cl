//{"column_indices":1,"elements":2,"result":4,"row_indices":0,"size":5,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const unsigned int* row_indices, global const uint4* column_indices, global const float4* elements, global const float* vector, global float* result, unsigned int size) {
  float dot_prod;
  unsigned int start, next_stop;
  uint4 col_idx;
  float4 tmp_vec;
  float4 tmp_entries;

  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    dot_prod = 0.0f;
    start = row_indices[hook(0, row)] / 4;
    next_stop = row_indices[hook(0, row + 1)] / 4;

    for (unsigned int i = start; i < next_stop; ++i) {
      col_idx = column_indices[hook(1, i)];

      tmp_entries = elements[hook(2, i)];
      tmp_vec.x = vector[hook(3, col_idx.x)];
      tmp_vec.y = vector[hook(3, col_idx.y)];
      tmp_vec.z = vector[hook(3, col_idx.z)];
      tmp_vec.w = vector[hook(3, col_idx.w)];

      dot_prod += dot(tmp_entries, tmp_vec);
    }
    result[hook(4, row)] = dot_prod;
  }
}