//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_nextafter(global float* src1, global float* src2, global float* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = nextafter(src1[hook(0, i)], src2[hook(1, i)]);
}