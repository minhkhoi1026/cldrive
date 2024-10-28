//{"cond":2,"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_switch_more_default(global int* out, global const int* in, global const int* cond) {
  unsigned int gid = get_global_id(0);
  int val = in[hook(1, gid)];
  switch (cond[hook(2, gid)]) {
    case 0:
      out[hook(0, gid)] = -val;
      break;
    case -1:
      out[hook(0, gid)] = val ^ 45;
      break;
    case 1:
      out[hook(0, gid)] = val - 17;
      break;
    case 42:
      out[hook(0, gid)] = val + 42;
      break;
    default:
      out[hook(0, gid)] = val & 1404;
  }
}