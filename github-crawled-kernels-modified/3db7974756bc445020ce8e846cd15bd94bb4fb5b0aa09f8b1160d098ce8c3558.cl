//{"buffer":0,"shared":2,"sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanBlocksVec(global int8* buffer, global int* sums, local int* shared) {
  unsigned int globalId = get_global_id(0);
  unsigned int localId = get_local_id(0);
  unsigned int n = get_local_size(0) * 2;

  unsigned int offset = 1;

  int8 val1 = buffer[hook(0, 2 * globalId + 0)];
  int8 val2 = buffer[hook(0, 2 * globalId + 1)];

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

  shared[hook(2, 2 * localId + 0)] = val1.s7;
  shared[hook(2, 2 * localId + 1)] = val2.s7;

  val1.s7 = 0;
  val2.s7 = 0;

  int tmp0 = val1.s3;
  val1.s3 = val1.s7;
  val1.s7 += tmp0;
  int tmp1 = val2.s3;
  val2.s3 = val2.s7;
  val2.s7 += tmp1;

  int tmp2 = val1.s1;
  val1.s1 = val1.s3;
  val1.s3 += tmp2;
  int tmp3 = val2.s1;
  val2.s1 = val2.s3;
  val2.s3 += tmp3;
  int tmp4 = val1.s5;
  val1.s5 = val1.s7;
  val1.s7 += tmp4;
  int tmp5 = val2.s5;
  val2.s5 = val2.s7;
  val2.s7 += tmp5;

  int tmp6 = val1.s0;
  val1.s0 = val1.s1;
  val1.s1 += tmp6;
  int tmp7 = val2.s0;
  val2.s0 = val2.s1;
  val2.s1 += tmp7;
  int tmp8 = val1.s2;
  val1.s2 = val1.s3;
  val1.s3 += tmp8;
  int tmp9 = val2.s2;
  val2.s2 = val2.s3;
  val2.s3 += tmp9;
  int tmp10 = val1.s4;
  val1.s4 = val1.s5;
  val1.s5 += tmp10;
  int tmp11 = val2.s4;
  val2.s4 = val2.s5;
  val2.s5 += tmp11;
  int tmp12 = val1.s6;
  val1.s6 = val1.s7;
  val1.s7 += tmp12;
  int tmp13 = val2.s6;
  val2.s6 = val2.s7;
  val2.s7 += tmp13;

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

  for (unsigned int d = 1; d < n; d *= 2) {
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

  val1 += shared[hook(2, 2 * localId + 0)];
  val2 += shared[hook(2, 2 * localId + 1)];

  buffer[hook(0, 2 * globalId + 0)] = val1;
  buffer[hook(0, 2 * globalId + 1)] = val2;
}