//{"pipe":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_convenience_write_uint(global unsigned int* src, write_only pipe unsigned int out_pipe) {
  int gid = get_global_id(0);
  write_pipe(out_pipe, &src[gid]);
}