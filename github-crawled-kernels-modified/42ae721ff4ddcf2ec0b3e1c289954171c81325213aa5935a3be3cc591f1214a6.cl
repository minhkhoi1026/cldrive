//{"argmin_val":6,"n":4,"pgx":5,"pgy":2,"px":0,"py":1,"skip":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_bw_kernel_8(const global float* px, const global float* py, const global float* pgy, const unsigned skip, const unsigned n, global float* pgx) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  const float min_val = py[hook(1, bid)];
  local unsigned argmin_val[8];
  px += bid % skip + (bid / skip) * skip * n;
  pgx += bid % skip + (bid / skip) * skip * n;
  unsigned thread_argmin = n;
  for (unsigned i = tid; i < n; i += 8) {
    if (px[hook(0, i * skip)] == min_val) {
      thread_argmin = min(i, thread_argmin);
    }
  }
  argmin_val[hook(6, tid)] = thread_argmin;
  barrier(0x01);
  if (8 >= 512 << 1) {
    if (tid < 512)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 512)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 256 << 1) {
    if (tid < 256)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 256)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 128 << 1) {
    if (tid < 128)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 128)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 64 << 1) {
    if (tid < 64)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 64)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 32 << 1) {
    if (tid < 32)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 32)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 16 << 1) {
    if (tid < 16)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 16)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 8 << 1) {
    if (tid < 8)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 8)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 4 << 1) {
    if (tid < 4)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 4)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 2 << 1) {
    if (tid < 2)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 2)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (8 >= 1 << 1) {
    if (tid < 1)
      argmin_val[hook(6, tid)] = min(argmin_val[hook(6, tid + 1)], argmin_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (tid == 0)
    pgx[hook(5, argmin_val[0hook(6, 0) * skip)] += pgy[hook(2, bid)];
}