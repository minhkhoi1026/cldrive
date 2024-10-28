//{"M":2,"M_internal_size2":3,"col":4,"vec":0,"vec_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_vector_to_matrix_col(global const float* vec, unsigned int vec_size, global float* M, unsigned int M_internal_size2, unsigned int col) {
  for (unsigned int i = get_global_id(0); i < vec_size; i += get_global_size(0)) {
    M[hook(2, i * M_internal_size2 + col)] = vec[hook(0, i)];
  }
}