//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__kernel void array_add(global const double* src1, global const double* src2, global double* dst) {
  int gid = get_global_id(0);
  dst[hook(2, gid)] = src1[hook(0, gid)] + src2[hook(1, gid)];
}