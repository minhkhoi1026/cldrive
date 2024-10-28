//{"dst":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_cross(global float* x, global float* y, global float* dst) {
  int tid = get_global_id(0);

  vstore3(cross(vload3(tid, x), vload3(tid, y)), tid, dst);
}