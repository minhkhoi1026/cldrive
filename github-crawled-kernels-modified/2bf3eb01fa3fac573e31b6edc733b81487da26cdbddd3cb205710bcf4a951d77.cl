//{"cols":2,"px":0,"py":3,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_fw_kernel(const global float* px, unsigned rows, unsigned cols, global float* py) {
  const unsigned i = get_global_id(0);
  const unsigned j = get_global_id(1);
  const unsigned bid_z = get_group_id(2);
  const unsigned ofs = bid_z * rows * cols;
  if (i < rows && j < cols)
    py[hook(3, ofs + j + i * cols)] = px[hook(0, ofs + i + j * rows)];
}