//{"dst":0,"pipe":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pipe_consumer(global float* dst, read_only pipe float in_pipe) {
  int gid = get_global_id(0);

  reserve_id_t res_id;
  res_id = reserve_read_pipe(in_pipe, 1);

  float dst_pipe;

  if (is_valid_reserve_id(res_id)) {
    if (read_pipe(in_pipe, res_id, 0, &dst_pipe) != 0)
      return;
    commit_read_pipe(in_pipe, res_id);
  }

  dst[hook(0, gid)] = dst_pipe * 3.0;
}