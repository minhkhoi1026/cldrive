//{"pipe":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pipe_producer(global float* src, write_only pipe float out_pipe) {
  int gid = get_global_id(0);

  reserve_id_t res_id;
  res_id = reserve_write_pipe(out_pipe, 1);

  float src_pipe = src[hook(0, gid)] * 2.0;

  if (is_valid_reserve_id(res_id)) {
    if (write_pipe(out_pipe, res_id, 0, &src_pipe) != 0)
      return;
    commit_write_pipe(out_pipe, res_id);
  }
}