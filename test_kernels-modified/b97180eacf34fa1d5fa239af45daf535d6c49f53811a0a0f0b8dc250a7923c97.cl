//{"buffer":0,"shared":2,"sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanBlocks(global int* buffer, global int* sums, local int* shared) {
  unsigned int globalId = get_global_id(0);
  unsigned int localId = get_local_id(0);
  unsigned int n = get_local_size(0) * 2;

  unsigned int offset = 1;

  shared[hook(2, 2 * localId + 0)] = buffer[hook(0, 2 * globalId + 0)];
  shared[hook(2, 2 * localId + 1)] = buffer[hook(0, 2 * globalId + 1)];

  for (unsigned int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;
      shared[hook(2, bi)] += shared[hook(2, ai)];
    }
    offset <<= 1;
  }
  barrier(0x01);

  if (localId == 0) {
    sums[hook(1, get_group_id(0))] = shared[hook(2, n - 1)];
    shared[hook(2, n - 1)] = 0;
  }

  for (unsigned int d = 1; d < n; d <<= 1) {
    offset >>= 1;
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;

      int t = shared[hook(2, ai)];
      shared[hook(2, ai)] = shared[hook(2, bi)];
      shared[hook(2, bi)] += t;
    }
  }
  barrier(0x01);

  buffer[hook(0, 2 * globalId + 0)] = shared[hook(2, 2 * localId + 0)];
  buffer[hook(0, 2 * globalId + 1)] = shared[hook(2, 2 * localId + 1)];
}