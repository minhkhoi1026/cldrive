//{"in":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int func_1(global int* in, int n) {
  return in[hook(0, n)];
}
kernel void func_0(global int* in, global int* out, int n) {
  out[hook(1, n)] = func_1(in, n);
}