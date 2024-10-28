//{"T":0,"ll_d":1,"sm":2,"smem":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FWD_sum_ll(const int T, global float* ll_d) {
  unsigned int lid = get_local_id(0);
  unsigned int gid = get_global_id(0);

  local float sm[64];

  if (gid < T) {
    sm[hook(2, lid)] = log10(ll_d[hook(1, gid)]);
  }

  barrier(0x01);

  if (lid < 32) {
    local float* smem = sm;
    smem[hook(3, lid)] += smem[hook(3, lid + 32)];
    smem[hook(3, lid)] += smem[hook(3, lid + 16)];
    smem[hook(3, lid)] += smem[hook(3, lid + 8)];
    smem[hook(3, lid)] += smem[hook(3, lid + 4)];
    smem[hook(3, lid)] += smem[hook(3, lid + 2)];
    smem[hook(3, lid)] += smem[hook(3, lid + 1)];
  }

  if (lid == 0) {
    ll_d[hook(1, T)] = sm[hook(2, 0)];
  }
}