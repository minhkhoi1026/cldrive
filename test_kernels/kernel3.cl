int hook(int argId, int id) {
	printf("%d,%d\n", argId, id);
	return id;
}
int func_3(local int* in, int n) {
  return in[hook(0,n)];
}
int func_2(local int* in, int n) {
  return func_3(in, n);
}
int func_1(local int* in, int n) {
  return func_2(in, n);
}
kernel void kernel_1(local int* in, global int* out, int nnn) {
  int gid = get_global_id(0);
  out[hook(1,gid + nnn)] = func_1(in, gid + nnn);
}
