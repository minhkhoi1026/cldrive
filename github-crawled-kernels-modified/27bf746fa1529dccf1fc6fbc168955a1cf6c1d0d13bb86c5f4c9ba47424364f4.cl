//{"pipe":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_write(global int* src, write_only pipe int out_pipe) {
  int gid = get_global_id(0);
  reserve_id_t res_id;
  res_id = reserve_write_pipe(out_pipe, 1);
  if (is_valid_reserve_id(res_id)) {
    write_pipe(out_pipe, res_id, 0, &src[gid]);
    commit_write_pipe(out_pipe, res_id);
  }
}