//{"fields":0,"fields_internal_size2":1,"illegalMove":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_environment(global float* fields, unsigned int fields_internal_size2, global bool* illegalMove) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < 3; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < 3; col += get_local_size(0))
      fields[hook(0, row * fields_internal_size2 + col)] = 0;
  }
  *illegalMove = false;
}