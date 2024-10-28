//{"input":0,"output":1,"sdata":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce4(global unsigned int* input, global unsigned int* output, local unsigned int* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int bid = get_group_id(0);
  unsigned int gid = get_global_id(0);
  unsigned int blockSize = get_local_size(0);

  unsigned int index = bid * (256 * 2) + tid;
  sdata[hook(2, tid)] = input[hook(0, index)] + input[hook(0, index + 256)];

  barrier(0x01);
  for (unsigned int s = 256 / 2; s > 64; s >>= 1) {
    if (tid < s) {
      sdata[hook(2, tid)] += sdata[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid < 64) {
    if (blockSize >= 128)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 64)];
    if (blockSize >= 64)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 32)];
    if (blockSize >= 32)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 16)];
    if (blockSize >= 16)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 8)];
    if (blockSize >= 8)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 4)];
    if (blockSize >= 4)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 2)];
    if (blockSize >= 2)
      sdata[hook(2, tid)] += sdata[hook(2, tid + 1)];
  }

  if (tid == 0)
    output[hook(1, bid)] = sdata[hook(2, 0)];
}