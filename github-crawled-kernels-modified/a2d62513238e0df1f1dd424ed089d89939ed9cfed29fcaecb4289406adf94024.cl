//{"cols":2,"px":3,"py":0,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_bw_kernel(const global float* py, const unsigned rows, const unsigned cols, global float* px) {
  const unsigned i = get_global_id(0);
  const unsigned j = get_global_id(1);
  const unsigned bid_z = get_group_id(2);
  const unsigned ofs = bid_z * rows * cols;
  if (i < rows && j < cols)
    px[hook(3, ofs + i + j * rows)] += py[hook(0, ofs + j + i * cols)];
}