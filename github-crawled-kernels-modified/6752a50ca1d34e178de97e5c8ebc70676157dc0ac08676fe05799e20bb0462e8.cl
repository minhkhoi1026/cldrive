//{"dst":3,"maxval":2,"minval":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global float* x, global float* minval, global float* maxval, global float* dst) {
  int tid = get_global_id(0);

  dst[hook(3, tid)] = clamp(x[hook(0, tid)], minval[hook(1, tid)], maxval[hook(2, tid)]);
}