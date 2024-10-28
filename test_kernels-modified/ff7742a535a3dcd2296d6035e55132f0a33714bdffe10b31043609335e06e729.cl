//{"in_max":1,"in_min":0,"out_min_max":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_min_max_reduce(global float4* in_min, global float4* in_max, global float4* out_min_max) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int lsize = get_local_size(0);
  float4 aux0, aux1;
  int it;

  for (it = lsize / 2; it > 0; it >>= 1) {
    if (lid < it) {
      aux0 = in_min[hook(0, lid + it)];
      aux1 = in_min[hook(0, lid)];
      in_min[hook(0, gid)] = min(aux0, aux1);

      aux0 = in_max[hook(1, lid + it)];
      aux1 = in_max[hook(1, lid)];
      in_max[hook(1, gid)] = max(aux0, aux1);
    }
    barrier(0x02);
  }
  if (lid == 0) {
    out_min_max[hook(2, 0)] = in_min[hook(0, gid)];
    out_min_max[hook(2, 1)] = in_max[hook(1, gid)];
  }
}