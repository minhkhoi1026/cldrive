//{"n":2,"px":0,"py":4,"r":3,"skip":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void flip_fw_kernel(const global float* px, unsigned skip, unsigned n, unsigned r, global float* py) {
  const unsigned i = get_global_id(0);
  const unsigned j = get_global_id(1);
  const unsigned offset = j * n - j % skip * (n - 1);
  if (i < n && j < r) {
    py[hook(4, offset + i * skip)] = px[hook(0, offset + (n - i - 1) * skip)];
  }
}