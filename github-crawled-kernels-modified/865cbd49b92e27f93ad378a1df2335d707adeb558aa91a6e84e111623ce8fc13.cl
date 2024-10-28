//{"dst":0,"numElems":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_red_recurse(global int* dst, global int* src, int numElems) {
  int index = 64 * get_global_id(0);

  if (index >= numElems)
    return;

  int i = index;

  if (i < 64)
    return;

  int a = 0;

  while (i >= 64) {
    a += src[hook(1, i)];
    i -= 64;
  }

  dst[hook(0, index)] = a;
}