//{"dst":1,"src":3,"srcEvents":0,"useOnlyGlobalTimestamps":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void QueryKernelTimestamps(global ulong* srcEvents, global ulong* dst, unsigned int useOnlyGlobalTimestamps) {
  unsigned int gid = get_global_id(0);
  const ulong tsMask = (1ull << 32) - 1;
  unsigned int currentOffset = gid * 4;
  dst[hook(1, currentOffset)] = 0;
  dst[hook(1, currentOffset + 1)] = 0;
  dst[hook(1, currentOffset + 2)] = 0;
  dst[hook(1, currentOffset + 3)] = 0;

  ulong srcPtr = srcEvents[hook(0, gid)];
  global unsigned int* src = (global unsigned int*)srcPtr;
  dst[hook(1, currentOffset)] = src[hook(3, 1)] & tsMask;
  dst[hook(1, currentOffset + 1)] = src[hook(3, 3)] & tsMask;
  if (useOnlyGlobalTimestamps != 0) {
    dst[hook(1, currentOffset + 2)] = src[hook(3, 1)] & tsMask;
    dst[hook(1, currentOffset + 3)] = src[hook(3, 3)] & tsMask;
  } else {
    dst[hook(1, currentOffset + 2)] = src[hook(3, 0)] & tsMask;
    dst[hook(1, currentOffset + 3)] = src[hook(3, 2)] & tsMask;
  }
}