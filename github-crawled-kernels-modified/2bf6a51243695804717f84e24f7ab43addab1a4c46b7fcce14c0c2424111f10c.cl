//{"inout":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* inout) {
  const int globalid = get_global_id(0);
  inout[hook(0, globalid)] = inout[hook(0, globalid)] + 7;
}