//{"dst":1,"e":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_frexp(global float* src, global float* dst, global int* e) {
  int i = get_global_id(0);
  dst[hook(1, i)] = frexp(src[hook(0, i)], &e[hook(2, i)]);
}