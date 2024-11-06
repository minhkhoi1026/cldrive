
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong calculateStride(const ulong elems, const ulong baseTypeSize) {
  ulong stride_bytes = ((elems * baseTypeSize + 0x03FF) & 0xFFFFFFFFFFFFFC00L);
  if (stride_bytes & 0x3FFFL == 0)
    stride_bytes |= 0x400L;
  const ulong stride_elems = stride_bytes / baseTypeSize;
  return stride_elems;
}

kernel void copySU3(global Matrixsu3* const restrict out, global const Matrixsu3* const restrict in, const ulong elems, const ulong threads_per_group) {
  size_t local_id = get_local_id(0);

  if (local_id >= threads_per_group)
    return;

  size_t id = get_group_id(0) * threads_per_group + local_id;

  for (size_t i = id; i < elems; i += threads_per_group * get_num_groups(0)) {
    Matrixsu3 tmp = in[i];
    out[hook(4, i)] = tmp;
  }
}