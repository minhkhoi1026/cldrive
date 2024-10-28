//{"A":0,"alpha":9,"inc1":3,"inc2":4,"internal_size1":7,"internal_size2":8,"size1":5,"size2":6,"start1":1,"start2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assign_cpu(global float* A, unsigned int start1, unsigned int start2, unsigned int inc1, unsigned int inc2, unsigned int size1, unsigned int size2, unsigned int internal_size1, unsigned int internal_size2, float alpha) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);

  for (unsigned int row = row_gid; row < size1; row += get_num_groups(0))
    for (unsigned int col = col_gid; col < size2; col += get_local_size(0))
      A[hook(0, (row * inc1 + start1) * internal_size2 + col * inc2 + start2)] = alpha;
}