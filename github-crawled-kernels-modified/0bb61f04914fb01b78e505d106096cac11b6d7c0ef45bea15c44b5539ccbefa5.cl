//{"block":4,"idxOffset":2,"input":1,"output":0,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void group_prefixSum(global unsigned int* output, global unsigned int* input, const int idxOffset, const int size, local unsigned int* block) {
  int localId = get_local_id(0);
  int localSize = get_local_size(0);
  int globalIdx = get_group_id(0);

  globalIdx = (idxOffset * (2 * (globalIdx * localSize + localId) + 1)) - 1;
  if (globalIdx < size) {
    block[hook(4, 2 * localId)] = input[hook(1, globalIdx)];
  }
  if (globalIdx + idxOffset < size) {
    block[hook(4, 2 * localId + 1)] = input[hook(1, globalIdx + idxOffset)];
  }

  int offset = 1;
  for (int l = size >> 1; l > 0; l >>= 1) {
    barrier(0x01);
    if (localId < l) {
      int ai = offset * (2 * localId + 1) - 1;
      int bi = offset * (2 * localId + 2) - 1;
      block[hook(4, bi)] += block[hook(4, ai)];
    }
    offset <<= 1;
  }

  if (size > 2) {
    if (offset < size) {
      offset <<= 1;
    }

    int maxThread = offset >> 1;
    for (int d = 0; d < maxThread; d <<= 1) {
      d += 1;
      offset >>= 1;
      barrier(0x01);

      if (localId < d) {
        int ai = offset * (localId + 1) - 1;
        int bi = ai + (offset >> 1);
        block[hook(4, bi)] += block[hook(4, ai)];
      }
    }
  }
  barrier(0x01);

  if (globalIdx < size) {
    output[hook(0, globalIdx)] = block[hook(4, 2 * localId)];
  }
  if (globalIdx + idxOffset < size) {
    output[hook(0, globalIdx + idxOffset)] = block[hook(4, 2 * localId + 1)];
  }
}