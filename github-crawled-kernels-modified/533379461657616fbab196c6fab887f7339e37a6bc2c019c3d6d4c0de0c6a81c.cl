//{"aux_max":4,"aux_min":3,"in":0,"n_pixels":5,"out_max":2,"out_min":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void two_stages_local_min_max_reduce(global const float4* in, global float4* out_min, global float4* out_max, local float4* aux_min, local float4* aux_max, int n_pixels) {
  int gid = get_global_id(0);
  int gsize = get_global_size(0);
  int lid = get_local_id(0);
  int lsize = get_local_size(0);
  float4 min_v = (float4)(0x1.fffffep127f);
  float4 max_v = (float4)(-0x1.fffffep127f);
  float4 in_v;
  float4 aux0, aux1;
  int it;

  for (it = gid; it < n_pixels; it += gsize) {
    in_v = in[hook(0, it)];
    min_v = min(min_v, in_v);
    max_v = max(max_v, in_v);
  }

  aux_min[hook(3, lid)] = min_v;
  aux_max[hook(4, lid)] = max_v;

  barrier(0x01);

  for (it = lsize / 2; it > 0; it >>= 1) {
    if (lid < it) {
      aux0 = aux_min[hook(3, lid + it)];
      aux1 = aux_min[hook(3, lid)];
      aux_min[hook(3, lid)] = min(aux0, aux1);

      aux0 = aux_max[hook(4, lid + it)];
      aux1 = aux_max[hook(4, lid)];
      aux_max[hook(4, lid)] = max(aux0, aux1);
    }
    barrier(0x01);
  }
  if (lid == 0) {
    out_min[hook(1, get_group_id(0))] = aux_min[hook(3, 0)];
    out_max[hook(2, get_group_id(0))] = aux_max[hook(4, 0)];
  }

  if (gid == 0) {
    int nb_wg = gsize / lsize;
    for (it = nb_wg; it < lsize; it++) {
      out_min[hook(1, it)] = (float4)(0x1.fffffep127f);
      out_max[hook(2, it)] = (float4)(-0x1.fffffep127f);
    }
  }
}