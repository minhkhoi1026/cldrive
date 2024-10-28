//{"argmax_val":6,"n":4,"pgx":5,"pgy":2,"px":0,"py":1,"skip":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_bw_kernel_1(const global float* px, const global float* py, const global float* pgy, const unsigned skip, const unsigned n, global float* pgx) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  const float max_val = py[hook(1, bid)];
  local unsigned argmax_val[1];
  px += bid % skip + (bid / skip) * skip * n;
  pgx += bid % skip + (bid / skip) * skip * n;
  unsigned thread_argmax = n;
  for (unsigned i = tid; i < n; i += 1) {
    if (px[hook(0, i * skip)] == max_val) {
      thread_argmax = min(i, thread_argmax);
    }
  }
  argmax_val[hook(6, tid)] = thread_argmax;
  barrier(0x01);
  if (1 >= 512 << 1) {
    if (tid < 512)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 512)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 256 << 1) {
    if (tid < 256)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 256)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 128 << 1) {
    if (tid < 128)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 128)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 64 << 1) {
    if (tid < 64)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 64)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 32 << 1) {
    if (tid < 32)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 32)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 16 << 1) {
    if (tid < 16)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 16)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 8 << 1) {
    if (tid < 8)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 8)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 4 << 1) {
    if (tid < 4)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 4)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 2 << 1) {
    if (tid < 2)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 2)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (1 >= 1 << 1) {
    if (tid < 1)
      argmax_val[hook(6, tid)] = min(argmax_val[hook(6, tid + 1)], argmax_val[hook(6, tid)]);
    barrier(0x01);
  }
  if (tid == 0)
    pgx[hook(5, argmax_val[0hook(6, 0) * skip)] += pgy[hook(2, bid)];
}