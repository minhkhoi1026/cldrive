//{"n":2,"px":4,"py":0,"r":3,"skip":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void flip_bw_kernel(const global float* py, unsigned skip, unsigned n, unsigned r, global float* px) {
  const unsigned i = get_global_id(0);
  const unsigned j = get_global_id(1);
  const unsigned offset = j * n - j % skip * (n - 1);
  if (i < n && j < r) {
    px[hook(4, offset + i * skip)] += py[hook(0, offset + (n - i - 1) * skip)];
  }
}