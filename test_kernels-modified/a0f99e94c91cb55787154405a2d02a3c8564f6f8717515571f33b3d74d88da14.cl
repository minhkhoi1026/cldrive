//{"mem":0,"size":2,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memset_int(global int* mem, int val, int size) {
  int px = get_global_id(0);
  if (px >= size)
    return;

  mem[hook(0, px)] = val;
}