//{"n":2,"px":0,"py":3,"skip":1,"temp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_fw_kernel_64(const global float* px, const unsigned skip, const unsigned n, global float* py) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  local float temp[64];
  px += bid % skip + (bid / skip) * skip * n;
  float thread_max = (__builtin_inff());
  for (unsigned i = tid; i < n; i += 64) {
    thread_max = min(px[hook(0, i * skip)], thread_max);
  }
  temp[hook(4, tid)] = thread_max;
  barrier(0x01);
  if (64 >= 512 << 1) {
    if (tid < 512)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 512)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 256 << 1) {
    if (tid < 256)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 256)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 128 << 1) {
    if (tid < 128)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 128)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 64 << 1) {
    if (tid < 64)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 64)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 32 << 1) {
    if (tid < 32)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 32)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 16 << 1) {
    if (tid < 16)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 16)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 8 << 1) {
    if (tid < 8)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 8)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 4 << 1) {
    if (tid < 4)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 4)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 2 << 1) {
    if (tid < 2)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 2)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (64 >= 1 << 1) {
    if (tid < 1)
      temp[hook(4, tid)] = min(temp[hook(4, tid + 1)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (tid == 0)
    py[hook(3, bid)] = temp[hook(4, 0)];
}