//{"firstLocalZeroIndex":3,"input":0,"output":1,"sdata":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorTotalByReduce(global double* input, global double* output, local double* sdata, int firstLocalZeroIndex) {
  unsigned int tid = get_local_id(0);
  unsigned int bid = get_group_id(0);
  unsigned int gid = get_global_id(0);
  unsigned int bnum = get_num_groups(0);

  unsigned int globalInputIndex = gid * 2;
  if (bid + 1 == bnum) {
    unsigned int localInputIndex = tid * 2;
    if (localInputIndex >= firstLocalZeroIndex)
      sdata[hook(2, tid)] = 0;
    else if (localInputIndex + 1 == firstLocalZeroIndex)
      sdata[hook(2, tid)] = input[hook(0, globalInputIndex)];
    else
      sdata[hook(2, tid)] = input[hook(0, globalInputIndex)] + input[hook(0, globalInputIndex + 1)];
  } else {
    sdata[hook(2, tid)] = input[hook(0, globalInputIndex)] + input[hook(0, globalInputIndex + 1)];
  }

  barrier(0x01);

  unsigned int localSize = get_local_size(0);
  for (unsigned int s = localSize >> 1; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(2, tid)] += sdata[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0)
    output[hook(1, bid)] = sdata[hook(2, 0)];
}