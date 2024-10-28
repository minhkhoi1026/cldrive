//{"incx":2,"local_sum":4,"n":0,"result":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sasum_slm_reduction(int n, global float* x, int incx, global float* result) {
  const int lid = get_local_id(0);
  const int gid = get_group_id(0);
  const int gnum = get_num_groups(0);
  const int ind = get_global_id(0);
  const int lsz = get_local_size(0);

  local float local_sum[256];

  local_sum[hook(4, lid)] = fabs(x[hook(1, ind * incx)]);

  if (gid == gnum - 1 && ind + 256 < n) {
    local_sum[hook(4, lid)] += fabs(x[hook(1, (ind + 256) * incx)]);
  }

  barrier(0x01);
  int plsz = lsz;
  for (int i = (lsz + 1) >> 1; plsz > 1; plsz = i, i = (i + 1) >> 1) {
    if (lid < i && plsz - lid - 1 != lid)
      local_sum[hook(4, lid)] += local_sum[hook(4, plsz - lid - 1)];
    barrier(0x01);
  }
  if (lid == 0)
    result[hook(3, gid)] = local_sum[hook(4, 0)];
}