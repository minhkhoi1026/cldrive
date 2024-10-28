//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k(global int* dst, constant int* src) {
  if (dst[hook(0, 0)] == 0)
    dst[hook(0, 0)] = 1;

  dst[hook(0, 0)] = src[hook(1, 0)];
}