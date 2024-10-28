//{"px":0,"py":4,"size":3,"skip1":1,"skip2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void broadcast_fw_kernel(const global float* px, const unsigned skip1, const unsigned skip2, const unsigned size, global float* py) {
  const unsigned i = get_global_id(0);
  if (i < size)
    py[hook(4, i)] = px[hook(0, i % skip1 + (i / skip2) * skip1)];
}