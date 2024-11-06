
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prescan(global unsigned int* const a, global unsigned int* const sums, local unsigned int* const tmp, const unsigned int n) {
  const size_t gid = get_global_id(0), lid = get_local_id(0), wgs = get_local_size(0);

  tmp[hook(2, 2 * lid)] = 2 * gid < n ? a[hook(0, 2 * gid)] : 0;
  tmp[hook(2, 2 * lid + 1)] = 2 * gid + 1 < n ? a[hook(0, 2 * gid + 1)] : 0;

  for (ushort d = wgs, ofs = 1; d; d >>= 1, ofs <<= 1) {
    barrier(0x01);
    if (lid < d)
      tmp[hook(2, (2 * lid + 2) * ofs - 1)] += tmp[hook(2, (2 * lid + 1) * ofs - 1)];
  }

  barrier(0x01);
  if (!lid) {
    sums[hook(1, get_group_id(0))] = tmp[hook(2, 2 * wgs - 1)];
    tmp[hook(2, 2 * wgs - 1)] = 0;
  }

  for (ushort d = 1, ofs = wgs; d <= wgs; d <<= 1, ofs >>= 1) {
    barrier(0x01);
    if (lid < d) {
      const size_t i = (2 * lid + 1) * ofs - 1, j = (2 * lid + 2) * ofs - 1;
      const unsigned int t = tmp[hook(2, i)];
      tmp[hook(2, i)] = tmp[hook(2, j)];
      tmp[hook(2, j)] += t;
    }
  }

  barrier(0x01);
  if (2 * gid < n)
    a[hook(0, 2 * gid)] = tmp[hook(2, 2 * lid)];
  if (2 * gid + 1 < n)
    a[hook(0, 2 * gid + 1)] = tmp[hook(2, 2 * lid + 1)];
}