//{"B":2,"dataSet":1,"input":5,"localBuf":0,"passesCount":4,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int scan_simt_exclusive(local int* input, size_t idx, const unsigned int lane) {
  if (lane > 0)
    input[hook(5, idx)] = input[hook(5, idx - 1)] + input[hook(5, idx)];
  if (lane > 1)
    input[hook(5, idx)] = input[hook(5, idx - 2)] + input[hook(5, idx)];
  if (lane > 3)
    input[hook(5, idx)] = input[hook(5, idx - 4)] + input[hook(5, idx)];
  if (lane > 7)
    input[hook(5, idx)] = input[hook(5, idx - 8)] + input[hook(5, idx)];
  if (lane > 15)
    input[hook(5, idx)] = input[hook(5, idx - 16)] + input[hook(5, idx)];

  return (lane > 0) ? input[hook(5, idx - 1)] : 0;
}

inline int scan_simt_inclusive(local int* input, size_t idx, const unsigned int lane) {
  if (lane > 0)
    input[hook(5, idx)] = input[hook(5, idx - 1)] + input[hook(5, idx)];
  if (lane > 1)
    input[hook(5, idx)] = input[hook(5, idx - 2)] + input[hook(5, idx)];
  if (lane > 3)
    input[hook(5, idx)] = input[hook(5, idx - 4)] + input[hook(5, idx)];
  if (lane > 7)
    input[hook(5, idx)] = input[hook(5, idx - 8)] + input[hook(5, idx)];
  if (lane > 15)
    input[hook(5, idx)] = input[hook(5, idx - 16)] + input[hook(5, idx)];

  return input[hook(5, idx)];
}

inline int scan_workgroup_exclusive(local int* localBuf, const unsigned int idx, const unsigned int lane, const unsigned int simt_bid) {
  int val = scan_simt_exclusive(localBuf, idx, lane);
  barrier(0x01);

  if (lane > 30)
    localBuf[hook(0, simt_bid)] = localBuf[hook(0, idx)];
  barrier(0x01);

  if (simt_bid < 1)
    scan_simt_inclusive(localBuf, idx, lane);
  barrier(0x01);

  if (simt_bid > 0)
    val = localBuf[hook(0, simt_bid - 1)] + val;
  barrier(0x01);

  localBuf[hook(0, idx)] = val;
  barrier(0x01);

  return val;
}

kernel void kernel__scan_block_anylength(local int* localBuf, global int* dataSet, const unsigned int B, unsigned int size, const unsigned int passesCount) {
  size_t idx = get_local_id(0);
  const unsigned int bidx = get_group_id(0);
  const unsigned int TC = get_local_size(0);

  const unsigned int lane = idx & 31;
  const unsigned int simt_bid = idx >> 5;

  int reduceValue = 0;

  for (unsigned int i = 0; i < passesCount; ++i) {
    const unsigned int offset = i * TC + (bidx * B);
    const unsigned int offsetIdx = offset + idx;

    if (offsetIdx > size - 1)
      return;

    int input = localBuf[hook(0, idx)] = dataSet[hook(1, offsetIdx)];
    barrier(0x01);

    int val = scan_workgroup_exclusive(localBuf, idx, lane, simt_bid);

    val = val + reduceValue;

    dataSet[hook(1, offsetIdx)] = val;

    if (idx == (TC - 1)) {
      localBuf[hook(0, idx)] = input + val;
    }
    barrier(0x01);

    reduceValue = localBuf[hook(0, TC - 1)];
    barrier(0x01);
  }
}