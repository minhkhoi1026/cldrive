//{"column_indices":1,"elements":2,"new_result":5,"old_result":4,"rhs":6,"row_indices":0,"size":7,"weight":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void jacobi(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, float weight, global const float* old_result, global float* new_result, global const float* rhs, unsigned int size) {
  float sum, diag = 1;
  int col;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    sum = 0;
    for (unsigned int j = row_indices[hook(0, i)]; j < row_indices[hook(0, i + 1)]; j++) {
      col = column_indices[hook(1, j)];
      if (i == col)
        diag = elements[hook(2, j)];
      else
        sum += elements[hook(2, j)] * old_result[hook(4, col)];
    }
    new_result[hook(5, i)] = weight * (rhs[hook(6, i)] - sum) / diag + (1 - weight) * old_result[hook(4, i)];
  }
}