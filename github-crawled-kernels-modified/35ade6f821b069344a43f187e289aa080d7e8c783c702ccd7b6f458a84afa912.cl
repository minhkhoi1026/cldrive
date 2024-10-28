//{"cond":2,"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_simple_if_else(global int* out, global const int* in, global const int* cond) {
  unsigned int gid = get_global_id(0);
  int val = in[hook(1, gid)];

  if (cond[hook(2, gid)] > 42) {
    out[hook(0, gid)] = val;
  } else {
    out[hook(0, gid)] = -val;
  }
}