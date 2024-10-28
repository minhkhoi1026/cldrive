//{"px":0,"py":5,"shift":6,"skip":2,"span":1,"x_size":3,"y_size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void concat_fw_kernel(const global float* px, const unsigned span, const unsigned skip, const unsigned x_size, const unsigned y_size, global float* py, const unsigned shift) {
  const unsigned i = get_global_id(0);
  if (i < y_size)
    py[hook(5, (i / span) * skip + (i % span) + shift)] = px[hook(0, i % x_size)];
}