//{"in":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int func_3(local int* in, int n) {
  return in[hook(0, n)];
}
int func_2(local int* in, int n) {
  return func_3(in, n);
}
int func_1(local int* in, int n) {
  return func_2(in, n);
}
kernel void kernel_2(local int* in, global int* out, int n) {
  out[hook(1, n)] = func_1(in, n);
}