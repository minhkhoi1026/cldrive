//{"input":0,"output":1,"sdata":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global uint4* input, global uint4* output, local uint4* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int bid = get_group_id(0);
  unsigned int gid = get_global_id(0);

  unsigned int localSize = get_local_size(0);
  unsigned int stride = gid * 2;
  sdata[hook(2, tid)] = input[hook(0, stride)] + input[hook(0, stride + 1)];

  barrier(0x01);

  for (unsigned int s = localSize >> 1; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(2, tid)] += sdata[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0)
    output[hook(1, bid)] = sdata[hook(2, 0)];
}