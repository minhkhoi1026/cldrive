//{"dst":1,"offsets":2,"src":4,"srcEvents":0,"useOnlyGlobalTimestamps":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void QueryKernelTimestampsWithOffsets(global ulong* srcEvents, global ulong* dst, global ulong* offsets, unsigned int useOnlyGlobalTimestamps) {
  unsigned int gid = get_global_id(0);
  const ulong tsMask = (1ull << 32) - 1;
  unsigned int currentOffset = offsets[hook(2, gid)] / 8;
  dst[hook(1, currentOffset)] = 0;
  dst[hook(1, currentOffset + 1)] = 0;
  dst[hook(1, currentOffset + 2)] = 0;
  dst[hook(1, currentOffset + 3)] = 0;

  ulong srcPtr = srcEvents[hook(0, gid)];
  global unsigned int* src = (global unsigned int*)srcPtr;
  dst[hook(1, currentOffset)] = src[hook(4, 1)] & tsMask;
  dst[hook(1, currentOffset + 1)] = src[hook(4, 3)] & tsMask;
  if (useOnlyGlobalTimestamps != 0) {
    dst[hook(1, currentOffset + 2)] = src[hook(4, 1)] & tsMask;
    dst[hook(1, currentOffset + 3)] = src[hook(4, 3)] & tsMask;
  } else {
    dst[hook(1, currentOffset + 2)] = src[hook(4, 0)] & tsMask;
    dst[hook(1, currentOffset + 3)] = src[hook(4, 2)] & tsMask;
  }
}