//{"ndims":1,"px":0,"py":5,"size":4,"x_strides":2,"y_strides":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void permute_dims_fw_kernel(const global float* px, const unsigned ndims, constant unsigned* x_strides, constant unsigned* y_strides, const unsigned size, global float* py) {
  const unsigned i = get_global_id(0);
  const unsigned bid_z = get_group_id(1);
  const unsigned ofs = bid_z * size;
  if (i < size) {
    unsigned tmp = i;
    unsigned j = 0;

    for (unsigned d = 0; d < ndims; ++d) {
      const unsigned p = tmp / x_strides[hook(2, d)];
      tmp -= p * x_strides[hook(2, d)];
      j += p * y_strides[hook(3, d)];
    }
    py[hook(5, ofs + j)] = px[hook(0, ofs + i)];
  }
}