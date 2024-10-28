//{"cond":2,"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_simple_if(global int* out, global const int* in, global const int* cond) {
  unsigned int gid = get_global_id(0);
  int val = in[hook(1, gid)];
  int factor = 1;

  if (cond[hook(2, gid)] > 42) {
    val += 17;
    factor = -3;
  }
  out[hook(0, gid)] = -val * factor;
}