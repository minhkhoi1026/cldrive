//{"n":2,"px":0,"py":3,"skip":1,"temp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_fw_kernel_4(const global float* px, const unsigned skip, const unsigned n, global float* py) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  local float temp[4];
  px += bid % skip + (bid / skip) * skip * n;
  float thread_max = -(__builtin_inff());
  for (unsigned i = tid; i < n; i += 4) {
    thread_max = max(px[hook(0, i * skip)], thread_max);
  }
  temp[hook(4, tid)] = thread_max;
  barrier(0x01);
  if (4 >= 512 << 1) {
    if (tid < 512)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 512)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 256 << 1) {
    if (tid < 256)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 256)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 128 << 1) {
    if (tid < 128)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 128)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 64 << 1) {
    if (tid < 64)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 64)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 32 << 1) {
    if (tid < 32)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 32)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 16 << 1) {
    if (tid < 16)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 16)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 8 << 1) {
    if (tid < 8)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 8)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 4 << 1) {
    if (tid < 4)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 4)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 2 << 1) {
    if (tid < 2)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 2)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (4 >= 1 << 1) {
    if (tid < 1)
      temp[hook(4, tid)] = max(temp[hook(4, tid + 1)], temp[hook(4, tid)]);
    barrier(0x01);
  }
  if (tid == 0)
    py[hook(3, bid)] = temp[hook(4, 0)];
}