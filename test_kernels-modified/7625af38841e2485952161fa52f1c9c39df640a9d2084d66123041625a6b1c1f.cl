//{"buffer":0,"shared":2,"sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanBlocksVecOptim(global int8* buffer, global int* sums, local int* shared) {
  unsigned int globalId = get_global_id(0) + get_group_id(0) * get_local_size(0);
  unsigned int localId = get_local_id(0);
  unsigned int n = get_local_size(0) * 2;

  unsigned int offset = 1;

  unsigned int ai = localId;
  unsigned int bi = localId + (n / 2);
  unsigned int bankOffsetA = ((ai) / 16);
  unsigned int bankOffsetB = ((bi) / 16);

  int8 val1 = buffer[hook(0, globalId)];
  int8 val2 = buffer[hook(0, globalId + (n / 2))];

  val1.s1 += val1.s0;
  val2.s1 += val2.s0;
  val1.s3 += val1.s2;
  val2.s3 += val2.s2;
  val1.s5 += val1.s4;
  val2.s5 += val2.s4;
  val1.s7 += val1.s6;
  val2.s7 += val2.s6;

  val1.s3 += val1.s1;
  val2.s3 += val2.s1;
  val1.s7 += val1.s5;
  val2.s7 += val2.s5;

  val1.s7 += val1.s3;
  val2.s7 += val2.s3;

  int sum1 = val1.s7;
  int sum2 = val2.s7;

  shared[hook(2, ai + bankOffsetA)] = sum1;
  shared[hook(2, bi + bankOffsetB)] = sum2;

  val1.s7 = 0;
  val2.s7 = 0;

  int tmp14 = val1.s3;
  val1.s3 = val1.s7;
  val1.s7 += tmp14;
  int tmp15 = val2.s3;
  val2.s3 = val2.s7;
  val2.s7 += tmp15;

  int tmp16 = val1.s1;
  val1.s1 = val1.s3;
  val1.s3 += tmp16;
  int tmp17 = val2.s1;
  val2.s1 = val2.s3;
  val2.s3 += tmp17;
  int tmp18 = val1.s5;
  val1.s5 = val1.s7;
  val1.s7 += tmp18;
  int tmp19 = val2.s5;
  val2.s5 = val2.s7;
  val2.s7 += tmp19;

  int tmp20 = val1.s0;
  val1.s0 = val1.s1;
  val1.s1 += tmp20;
  int tmp21 = val2.s0;
  val2.s0 = val2.s1;
  val2.s1 += tmp21;
  int tmp22 = val1.s2;
  val1.s2 = val1.s3;
  val1.s3 += tmp22;
  int tmp23 = val2.s2;
  val2.s2 = val2.s3;
  val2.s3 += tmp23;
  int tmp24 = val1.s4;
  val1.s4 = val1.s5;
  val1.s5 += tmp24;
  int tmp25 = val2.s4;
  val2.s4 = val2.s5;
  val2.s5 += tmp25;
  int tmp26 = val1.s6;
  val1.s6 = val1.s7;
  val1.s7 += tmp26;
  int tmp27 = val2.s6;
  val2.s6 = val2.s7;
  val2.s7 += tmp27;

  for (unsigned int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;
      ai += ((ai) / 16);
      bi += ((bi) / 16);

      shared[hook(2, bi)] += shared[hook(2, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);
  if (localId == 0) {
    unsigned int index = n - 1 + ((n - 1) / 16);
    sums[hook(1, get_group_id(0))] = shared[hook(2, index)];

    shared[hook(2, index)] = 0;
  }

  for (unsigned int d = 1; d < n; d *= 2) {
    offset >>= 1;
    barrier(0x01);
    if (localId < d) {
      unsigned int ai = offset * (2 * localId + 1) - 1;
      unsigned int bi = offset * (2 * localId + 2) - 1;
      ai += ((ai) / 16);
      bi += ((bi) / 16);

      int t = shared[hook(2, ai)];
      shared[hook(2, ai)] = shared[hook(2, bi)];
      shared[hook(2, bi)] += t;
    }
  }
  barrier(0x01);

  val1 += shared[hook(2, ai + bankOffsetA)];
  val2 += shared[hook(2, bi + bankOffsetB)];

  buffer[hook(0, globalId)] = val1;
  buffer[hook(0, globalId + (n / 2))] = val2;
}