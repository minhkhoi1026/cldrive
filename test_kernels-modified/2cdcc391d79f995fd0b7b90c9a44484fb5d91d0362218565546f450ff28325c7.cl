//{"in":0,"maximas":2,"n":3,"tmp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global const double* const in, local double* const tmp, global double* const maximas, const unsigned int n) {
  const size_t gid = get_global_id(0), lid = get_local_id(0), wgs = get_local_size(0), wgid = get_group_id(0);

  const unsigned int stride = wgid * wgs;
  tmp[hook(1, lid)] = stride + gid < n ? fabs(in[hook(0, stride + gid)]) : 0.;
  tmp[hook(1, lid + wgs)] = stride + gid + wgs < n ? fabs(in[hook(0, stride + gid + wgs)]) : 0.;

  for (ushort offset = wgs; offset; offset >>= 1) {
    barrier(0x01);
    if (lid < offset)
      tmp[hook(1, lid)] = max(tmp[hook(1, lid)], tmp[hook(1, lid + offset)]);
  }

  barrier(0x01);
  if (!lid)
    maximas[hook(2, wgid)] = tmp[hook(1, 0)];
}