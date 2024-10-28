//{"n":2,"px":0,"py":3,"skip":1,"temp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_fw_kernel_32(const global float* px, const unsigned skip, const unsigned n, global float* py) {
  const unsigned bid = get_group_id(0);
  const unsigned tid = get_local_id(0);
  local float temp[32];
  px += bid % skip + (bid / skip) * skip * n;
  temp[hook(4, tid)] = 0;
  for (unsigned i = tid; i < n; i += 32)
    temp[hook(4, tid)] += px[hook(0, i * skip)];
  barrier(0x01);
  if (32 >= 512 << 1) {
    if (tid < 512)
      temp[hook(4, tid)] += temp[hook(4, tid + 512)];
    barrier(0x01);
  }
  if (32 >= 256 << 1) {
    if (tid < 256)
      temp[hook(4, tid)] += temp[hook(4, tid + 256)];
    barrier(0x01);
  }
  if (32 >= 128 << 1) {
    if (tid < 128)
      temp[hook(4, tid)] += temp[hook(4, tid + 128)];
    barrier(0x01);
  }
  if (32 >= 64 << 1) {
    if (tid < 64)
      temp[hook(4, tid)] += temp[hook(4, tid + 64)];
    barrier(0x01);
  }
  if (32 >= 32 << 1) {
    if (tid < 32)
      temp[hook(4, tid)] += temp[hook(4, tid + 32)];
    barrier(0x01);
  }
  if (32 >= 16 << 1) {
    if (tid < 16)
      temp[hook(4, tid)] += temp[hook(4, tid + 16)];
    barrier(0x01);
  }
  if (32 >= 8 << 1) {
    if (tid < 8)
      temp[hook(4, tid)] += temp[hook(4, tid + 8)];
    barrier(0x01);
  }
  if (32 >= 4 << 1) {
    if (tid < 4)
      temp[hook(4, tid)] += temp[hook(4, tid + 4)];
    barrier(0x01);
  }
  if (32 >= 2 << 1) {
    if (tid < 2)
      temp[hook(4, tid)] += temp[hook(4, tid + 2)];
    barrier(0x01);
  }
  if (32 >= 1 << 1) {
    if (tid < 1)
      temp[hook(4, tid)] += temp[hook(4, tid + 1)];
    barrier(0x01);
  }
  if (tid == 0)
    py[hook(3, bid)] = temp[hook(4, 0)];
}