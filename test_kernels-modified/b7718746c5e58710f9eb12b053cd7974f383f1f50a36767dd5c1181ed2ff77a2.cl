//{"dst":1,"it":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_modf(global float* src, global float* dst, global float* it) {
  int i = get_global_id(0);
  float x;
  dst[hook(1, i)] = modf(src[hook(0, i)], &x);
  it[hook(2, i)] = x;
}