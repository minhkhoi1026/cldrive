//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product_child(global const int* a, global int* b, global int* c) {
  int gid = get_global_id(0);
  int res;
  int max = get_global_size(0);
  if (gid < 128)
    res = b[hook(1, gid)] + b[hook(1, gid + 128)];
  else if (gid > max - 128)
    res = b[hook(1, gid)] + b[hook(1, gid - 128)];
  else
    res = b[hook(1, gid - 128)] + b[hook(1, gid)] + b[hook(1, gid + 128)];

  c[hook(2, gid)] = res;
}