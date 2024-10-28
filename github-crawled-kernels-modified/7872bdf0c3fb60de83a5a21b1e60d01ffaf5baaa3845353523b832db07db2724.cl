//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_test2(global int* src, global float* dst) {
  int tid = get_global_id(0);
  dst[hook(1, tid)] = (float)src[hook(0, tid)];
}