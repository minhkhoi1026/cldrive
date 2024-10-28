//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_convenience_read_uint(read_only pipe unsigned int in_pipe, global unsigned int* dst) {
  int gid = get_global_id(0);
  read_pipe(in_pipe, &dst[gid]);
}