//{"pipe":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_workgroup_write_char(global char* src, write_only pipe char out_pipe) {
  int gid = get_global_id(0);
  local reserve_id_t res_id;

  res_id = work_group_reserve_write_pipe(out_pipe, get_local_size(0));
  if (is_valid_reserve_id(res_id)) {
    write_pipe(out_pipe, res_id, get_local_id(0), &src[gid]);
    work_group_commit_write_pipe(out_pipe, res_id);
  }
}