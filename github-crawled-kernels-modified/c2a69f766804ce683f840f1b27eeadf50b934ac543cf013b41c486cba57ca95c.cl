//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_read(read_only pipe int in_pipe, global int* dst) {
  int gid = get_global_id(0);
  reserve_id_t res_id;
  res_id = reserve_read_pipe(in_pipe, 1);
  if (is_valid_reserve_id(res_id)) {
    read_pipe(in_pipe, res_id, 0, &dst[gid]);
    commit_read_pipe(in_pipe, res_id);
  }
}