//{"dev":3,"numItems":4,"op1":0,"op2":1,"ret":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vadd(global uint4* op1, global uint4* op2, global uint4* ret, unsigned int dev, unsigned int numItems) {
  unsigned int count = (numItems / 4) / get_global_size(0);
  unsigned int idx = (dev == 0) ? (get_global_id(0) * count) : get_global_id(0);

  unsigned int stride = (dev == 0) ? 1 : get_global_size(0);

  for (unsigned int i = 0; i < count; ++i, idx += stride) {
    ret[hook(2, idx)] = op1[hook(0, idx)] + op2[hook(1, idx)];
  }
}