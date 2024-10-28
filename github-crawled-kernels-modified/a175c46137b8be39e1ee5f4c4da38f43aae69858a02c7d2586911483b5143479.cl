//{"k":1,"px":0,"py":3,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pown_fw_kernel(const global float* px, const int k, const unsigned size, global float* py) {
  const unsigned i = get_global_id(0);
  if (i < size)
    py[hook(3, i)] = pown(px[hook(0, i)], k);
}