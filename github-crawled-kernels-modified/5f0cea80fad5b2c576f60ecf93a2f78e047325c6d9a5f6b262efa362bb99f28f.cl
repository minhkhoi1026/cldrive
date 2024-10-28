//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_workgroup_read_char(read_only pipe char in_pipe, global char* dst) {
  int gid = get_global_id(0);
  local reserve_id_t res_id;

  res_id = work_group_reserve_read_pipe(in_pipe, get_local_size(0));
  if (is_valid_reserve_id(res_id)) {
    read_pipe(in_pipe, res_id, get_local_id(0), &dst[gid]);
    work_group_commit_read_pipe(in_pipe, res_id);
  }
}