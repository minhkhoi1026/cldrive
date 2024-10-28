//{"column_indices":1,"elements":2,"result":4,"row_indices":0,"size":5,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul_cpu(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global const float* vector, global float* result, unsigned int size) {
  unsigned int work_per_item = max((unsigned int)(size / get_global_size(0)), (unsigned int)1);
  unsigned int row_start = get_global_id(0) * work_per_item;
  unsigned int row_stop = min((unsigned int)((get_global_id(0) + 1) * work_per_item), (unsigned int)size);
  for (unsigned int row = row_start; row < row_stop; ++row) {
    float dot_prod = 0.0f;
    unsigned int row_end = row_indices[hook(0, row + 1)];
    for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i)
      dot_prod += elements[hook(2, i)] * vector[hook(3, column_indices[ihook(1, i))];
    result[hook(4, row)] = dot_prod;
  }
}