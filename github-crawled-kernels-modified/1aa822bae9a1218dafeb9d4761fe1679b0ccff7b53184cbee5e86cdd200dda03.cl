//{"current_player":3,"fields":1,"fields_internal_size2":2,"sight":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_sight(global float* sight, global float* fields, unsigned int fields_internal_size2, int current_player) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < 3; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < 3; col += get_local_size(0)) {
      int fieldValue = current_player * fields[hook(1, row * fields_internal_size2 + col)];
      if (fieldValue == 1)
        sight[hook(0, (row * 3 + col) * 2)] = 1;
      else
        sight[hook(0, (row * 3 + col) * 2)] = 0;

      if (fieldValue == -1)
        sight[hook(0, (row * 3 + col) * 2 + 1)] = 1;
      else
        sight[hook(0, (row * 3 + col) * 2 + 1)] = 0;
    }
  }
}