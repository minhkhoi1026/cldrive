//{"blockOffsets":2,"counters":1,"keys":0,"numElements":4,"numtrue":10,"ptr":9,"sData":7,"sMem":11,"sRadix1":6,"sStartPointers":12,"startbit":3,"sum":8,"totalBlocks":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int scanwarp(unsigned int val, volatile local unsigned int* sData, int maxlevel) {
  int localId = get_local_id(0);
  int idx = 2 * localId - (localId & (32 - 1));
  sData[hook(7, idx)] = 0;
  idx += 32;
  sData[hook(7, idx)] = val;

  if (0 <= maxlevel) {
    sData[hook(7, idx)] += sData[hook(7, idx - 1)];
  }
  if (1 <= maxlevel) {
    sData[hook(7, idx)] += sData[hook(7, idx - 2)];
  }
  if (2 <= maxlevel) {
    sData[hook(7, idx)] += sData[hook(7, idx - 4)];
  }
  if (3 <= maxlevel) {
    sData[hook(7, idx)] += sData[hook(7, idx - 8)];
  }
  if (4 <= maxlevel) {
    sData[hook(7, idx)] += sData[hook(7, idx - 16)];
  }

  return sData[hook(7, idx)] - val;
}

uint4 scan4(uint4 idata, local unsigned int* ptr) {
  unsigned int idx = get_local_id(0);

  uint4 val4 = idata;
  unsigned int sum[3];
  sum[hook(8, 0)] = val4.x;
  sum[hook(8, 1)] = val4.y + sum[hook(8, 0)];
  sum[hook(8, 2)] = val4.z + sum[hook(8, 1)];

  unsigned int val = val4.w + sum[hook(8, 2)];

  val = scanwarp(val, ptr, 4);
  barrier(0x01);

  if ((idx & (32 - 1)) == 32 - 1) {
    ptr[hook(9, idx >> 5)] = val + val4.w + sum[hook(8, 2)];
  }
  barrier(0x01);

  if (idx < 32)
    ptr[hook(9, idx)] = scanwarp(ptr[hook(9, idx)], ptr, 2);

  barrier(0x01);

  val += ptr[hook(9, idx >> 5)];

  val4.x = val;
  val4.y = val + sum[hook(8, 0)];
  val4.z = val + sum[hook(8, 1)];
  val4.w = val + sum[hook(8, 2)];

  return val4;
}

uint4 rank4(uint4 preds, local unsigned int* sMem, local unsigned int* numtrue) {
  int localId = get_local_id(0);
  int localSize = get_local_size(0);

  uint4 address = scan4(preds, sMem);

  if (localId == localSize - 1) {
    numtrue[hook(10, 0)] = address.w + preds.w;
  }
  barrier(0x01);

  uint4 rank;
  int idx = localId * 4;
  rank.x = (preds.x) ? address.x : numtrue[hook(10, 0)] + idx - address.x;
  rank.y = (preds.y) ? address.y : numtrue[hook(10, 0)] + idx + 1 - address.y;
  rank.z = (preds.z) ? address.z : numtrue[hook(10, 0)] + idx + 2 - address.z;
  rank.w = (preds.w) ? address.w : numtrue[hook(10, 0)] + idx + 3 - address.w;

  return rank;
}

void radixSortBlockKeysOnly(uint4* key, unsigned int nbits, unsigned int startbit, local unsigned int* sMem, local unsigned int* numtrue) {
  int localId = get_local_id(0);
  int localSize = get_local_size(0);

  for (unsigned int shift = startbit; shift < (startbit + nbits); ++shift) {
    uint4 lsb;
    lsb.x = !(((*key).x >> shift) & 0x1);
    lsb.y = !(((*key).y >> shift) & 0x1);
    lsb.z = !(((*key).z >> shift) & 0x1);
    lsb.w = !(((*key).w >> shift) & 0x1);

    uint4 r;

    r = rank4(lsb, sMem, numtrue);

    sMem[hook(11, (r.x & 3) * localSize + (r.x >> 2))] = (*key).x;
    sMem[hook(11, (r.y & 3) * localSize + (r.y >> 2))] = (*key).y;
    sMem[hook(11, (r.z & 3) * localSize + (r.z >> 2))] = (*key).z;
    sMem[hook(11, (r.w & 3) * localSize + (r.w >> 2))] = (*key).w;
    barrier(0x01);

    (*key).x = sMem[hook(11, localId)];
    (*key).y = sMem[hook(11, localId + localSize)];
    (*key).z = sMem[hook(11, localId + 2 * localSize)];
    (*key).w = sMem[hook(11, localId + 3 * localSize)];

    barrier(0x01);
  }
}

kernel void findRadixOffsets(global uint2* keys, global unsigned int* counters, global unsigned int* blockOffsets, unsigned int startbit, unsigned int numElements, unsigned int totalBlocks, local unsigned int* sRadix1) {
  local unsigned int sStartPointers[16];

  unsigned int groupId = get_group_id(0);
  unsigned int localId = get_local_id(0);
  unsigned int groupSize = get_local_size(0);

  uint2 radix2;

  radix2 = keys[hook(0, get_global_id(0))];

  sRadix1[hook(6, 2 * localId)] = (radix2.x >> startbit) & 0xF;
  sRadix1[hook(6, 2 * localId + 1)] = (radix2.y >> startbit) & 0xF;

  if (localId < 16) {
    sStartPointers[hook(12, localId)] = 0;
  }
  barrier(0x01);

  if ((localId > 0) && (sRadix1[hook(6, localId)] != sRadix1[hook(6, localId - 1)])) {
    sStartPointers[hook(12, sRadix1[lhook(6, localId))] = localId;
  }
  if (sRadix1[hook(6, localId + groupSize)] != sRadix1[hook(6, localId + groupSize - 1)]) {
    sStartPointers[hook(12, sRadix1[lhook(6, localId + groupSize))] = localId + groupSize;
  }
  barrier(0x01);

  if (localId < 16) {
    blockOffsets[hook(2, groupId * 16 + localId)] = sStartPointers[hook(12, localId)];
  }
  barrier(0x01);

  if ((localId > 0) && (sRadix1[hook(6, localId)] != sRadix1[hook(6, localId - 1)])) {
    sStartPointers[hook(12, sRadix1[lhook(6, localId - 1))] = localId - sStartPointers[hook(12, sRadix1[lhook(6, localId - 1))];
  }
  if (sRadix1[hook(6, localId + groupSize)] != sRadix1[hook(6, localId + groupSize - 1)]) {
    sStartPointers[hook(12, sRadix1[lhook(6, localId + groupSize - 1))] = localId + groupSize - sStartPointers[hook(12, sRadix1[lhook(6, localId + groupSize - 1))];
  }

  if (localId == groupSize - 1) {
    sStartPointers[hook(12, sRadix1[2hook(6, 2 * groupSize - 1))] = 2 * groupSize - sStartPointers[hook(12, sRadix1[2hook(6, 2 * groupSize - 1))];
  }
  barrier(0x01);

  if (localId < 16) {
    counters[hook(1, localId * totalBlocks + groupId)] = sStartPointers[hook(12, localId)];
  }
}