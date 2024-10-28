//{"column_indices":1,"elements":2,"result":4,"row_indices":0,"size":5,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global const float* vector, global float* result, unsigned int size) {
  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    float dot_prod = 0.0f;
    unsigned int row_end = row_indices[hook(0, row + 1)];
    for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i)
      dot_prod += elements[hook(2, i)] * vector[hook(3, column_indices[ihook(1, i))];
    result[hook(4, row)] = dot_prod;
  }
}