//{"foundIndices":4,"foundIndicesNumBuf":3,"gSumChanges":1,"inputSums":2,"n":0,"sumChanges":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subsetSumNaiveKernel(unsigned int n, const global long* gSumChanges, const global long* inputSums, global unsigned int* foundIndicesNumBuf, global unsigned int* foundIndices) {
  local long sumChanges[41];
  unsigned int gi = get_global_id(0);
  unsigned int li = get_local_id(0);

  const unsigned int grpSize = get_local_size(0);
  for (unsigned int j = 0; j < 41; j += grpSize)
    if (j + li < 41)
      sumChanges[hook(5, j + li)] = gSumChanges[hook(1, j + li)];
  barrier(0x01);

  if (gi >= n)
    return;

  const long inputSum = inputSums[hook(2, gi)];

  const long v0 = sumChanges[hook(5, 32 + 0)];
  const long v1 = sumChanges[hook(5, 32 + 1)] - v0;
  const long s1 = v0 + sumChanges[hook(5, 32 + 1)];
  const long v2 = sumChanges[hook(5, 32 + 2)] - s1;
  const long s2 = s1 + sumChanges[hook(5, 32 + 2)];
  const long v3 = sumChanges[hook(5, 32 + 3)] - s2;
  const long s3 = s2 + sumChanges[hook(5, 32 + 3)];
  const long v4 = sumChanges[hook(5, 32 + 4)] - s3;
  const long s4 = s3 + sumChanges[hook(5, 32 + 4)];
  const long v5 = sumChanges[hook(5, 32 + 5)] - s4;
  const long s5 = s4 + sumChanges[hook(5, 32 + 5)];
  const long v6 = sumChanges[hook(5, 32 + 6)] - s5;
  const long s6 = s5 + sumChanges[hook(5, 32 + 6)];
  const long v7 = sumChanges[hook(5, 32 + 7)] - s6;
  const long s7 = s6 + sumChanges[hook(5, 32 + 7)];
  const long v8 = sumChanges[hook(5, 32 + 8)] - s7;

  unsigned int curFoundIdx = 0xffffffffU;

  for (unsigned int current = 0; current < 32; current++) {
    unsigned int find = 0;
    long sum = inputSum + sumChanges[hook(5, current)];
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v6;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v7;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v6;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v8;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v6;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v7;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v6;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v5;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v4;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v3;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v2;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);
    sum += v1;
    find |= (sum == 0);
    sum += v0;
    find |= (sum == 0);

    if (find) {
      if (curFoundIdx == 0xffffffffU) {
        curFoundIdx = atomic_inc(foundIndicesNumBuf);
        foundIndices[hook(4, curFoundIdx * 2 + 1)] = 0;
        foundIndices[hook(4, curFoundIdx * 2)] = gi;
      }
      foundIndices[hook(4, curFoundIdx * 2 + 1)] |= 1U << current;
    }
  }
}