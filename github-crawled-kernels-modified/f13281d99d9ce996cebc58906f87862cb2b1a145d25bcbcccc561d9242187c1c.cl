//{"dst":0,"max_func":3,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_pow(global float* dst, global float* src1, global float* src2, global int* max_func) {
  int i = get_global_id(0);
  dst[hook(0, i * (*max_func) + 0)] = pow(src1[hook(1, i)], src2[hook(2, i)]);
  dst[hook(0, i * (*max_func) + 1)] = src1[hook(1, i)];
}