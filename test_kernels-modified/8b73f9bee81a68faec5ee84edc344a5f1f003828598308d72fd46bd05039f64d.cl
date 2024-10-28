//{"a":0,"b":1,"len":3,"res":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_vec_gpu(global const int* a, global const int* b, global int* res, const int len) {
  const int idx = get_global_id(0);
  if (idx < len)
    res[hook(2, idx)] = a[hook(0, idx)] + b[hook(1, idx)];
}