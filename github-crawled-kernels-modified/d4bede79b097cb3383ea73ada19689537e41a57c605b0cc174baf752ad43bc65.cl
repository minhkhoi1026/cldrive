//{"buffer":0,"shared":2,"sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanBlocksOptim(global int* buffer, global int* sums, local int* shared) {
  unsigned int globalId = get_global_id(0) + get_group_id(0) * get_local_size(0);
  unsigned int localId = get_local_id(0);
  unsigned int n = get_local_size(0) * 2;

  unsigned int offset = 1;

  unsigned int ai = localId;
  unsigned int bi = localId + (n / 2);
  unsigned int bankOffsetA = (((ai) >> (16 + (ai))) >> (2 * 4));
  unsigned int bankOffsetB = (((bi) >> (16 + (bi))) >> (2 * 4));
  shared[hook(2, ai + bankOffsetA)] = buffer[hook(0, globalId)];
  shared[hook(2, bi + bankOffsetB)] = buffer[hook(0, globalId + (n / 2))];

  for (unsigned int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;
      ai += (((ai) >> (16 + (ai))) >> (2 * 4));
      bi += (((bi) >> (16 + (bi))) >> (2 * 4));

      int aa = shared[hook(2, ai)];
      int bb = shared[hook(2, bi)];

      shared[hook(2, bi)] += shared[hook(2, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);
  if (localId == 0) {
    unsigned int index = n - 1 + (((n - 1) >> (16 + (n - 1))) >> (2 * 4));
    sums[hook(1, get_group_id(0))] = shared[hook(2, index)];

    shared[hook(2, index)] = 0;
  }

  for (unsigned int d = 1; d < n; d <<= 1) {
    offset >>= 1;
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;
      ai += (((ai) >> (16 + (ai))) >> (2 * 4));
      bi += (((bi) >> (16 + (bi))) >> (2 * 4));

      int t = shared[hook(2, ai)];
      shared[hook(2, ai)] = shared[hook(2, bi)];
      shared[hook(2, bi)] += t;
    }
  }
  barrier(0x01);

  int aaa = shared[hook(2, ai + bankOffsetA)];
  int bbb = shared[hook(2, bi + bankOffsetB)];
  buffer[hook(0, globalId)] = shared[hook(2, ai + bankOffsetA)];
  buffer[hook(0, globalId + (n / 2))] = shared[hook(2, bi + bankOffsetB)];
}