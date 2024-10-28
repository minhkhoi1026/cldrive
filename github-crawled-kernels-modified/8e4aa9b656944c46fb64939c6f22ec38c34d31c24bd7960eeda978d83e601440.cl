//{"dst":3,"src1":0,"src2":1,"src3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_bitselect(global float* src1, global float* src2, global float* src3, global float* dst) {
  int i = get_global_id(0);
  dst[hook(3, i)] = bitselect(src1[hook(0, i)], src2[hook(1, i)], src3[hook(2, i)]);
}