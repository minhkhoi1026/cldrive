//{"in":0,"inout":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global int* in, global int* out, global int* inout) {
  const int globalid = get_global_id(0);
  inout[hook(2, globalid)] = inout[hook(2, globalid)] + 7;
  out[hook(1, globalid)] = in[hook(0, globalid)] + 5;
  if (globalid == 2) {
    out[hook(1, globalid)] = 26;
    inout[hook(2, globalid)] = 34;
  }
}