//{"a":0,"a4":4,"lsum":5,"m":2,"n":3,"sum":1,"sum4":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prescanReduce(global unsigned int const* restrict a, global unsigned int* restrict sum, unsigned int m, unsigned int n) {
  size_t localID = get_local_id(0);
  size_t groupID = get_group_id(0);

  local unsigned int lsum[256];

  m >>= 2;
  global uint4* a4 = (global uint4*)a;

  size_t startIndex = m * groupID;
  size_t stopIndex = startIndex + m;

  uint4 sum4 = 0;
  for (size_t i = startIndex; i < stopIndex; i += 256)
    sum4 += a4[hook(4, i + localID)];

  lsum[hook(5, localID)] = sum4.x + sum4.y + sum4.z + sum4.w;

  barrier(0x01);

  for (size_t offset = 128; offset >= 2; offset >>= 1) {
    if (localID < offset)
      lsum[hook(5, localID)] += lsum[hook(5, localID + offset)];
    barrier(0x01);
  }

  if (localID == 0)
    sum[hook(1, groupID)] = lsum[hook(5, localID)] + lsum[hook(5, localID + 1)];
}

kernel __attribute__((reqd_work_group_size(16, 1, 1))) void prescanLocal16(global unsigned int* restrict sum) {
  size_t localID = get_local_id(0);

  local unsigned int lsum[16 + 16 / 2];
  global uint4* sum4 = (global uint4*)sum;

  if (localID < 16 / 2)
    lsum[hook(5, localID)] = 0;

  size_t idx = localID + 16 / 2;

  uint4 val = sum4[hook(6, localID)];
  lsum[hook(5, idx)] = val.x + val.y + val.z + val.w;

  lsum[hook(5, idx)] += lsum[hook(5, idx - 1)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 2)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 4)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 8)];

  unsigned int p = lsum[hook(5, idx - 1)];
  uint4 result;
  result.x = p;
  p += val.x;
  result.y = p;
  p += val.y;
  result.z = p;
  p += val.z;
  result.w = p;
  sum4[hook(6, localID)] = result;
}

kernel __attribute__((reqd_work_group_size(64, 1, 1))) void prescanLocal64(global unsigned int* restrict sum) {
  local unsigned int lsum[32 + 64];
  global uint4* sum4 = (global uint4*)sum;

  size_t localID = get_local_id(0);
  size_t idx = localID + 32;

  lsum[hook(5, localID)] = 0;

  uint4 val = sum4[hook(6, localID)];
  unsigned int sl = val.x + val.y, sh = val.z + val.w;
  uint4 res = (uint4)(sl + sh, val.y + sh, sh, val.w);
  lsum[hook(5, idx)] = res.x;

  lsum[hook(5, idx)] += lsum[hook(5, idx - 1)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 2)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 4)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 8)];
  lsum[hook(5, idx)] += lsum[hook(5, idx - 16)];

  unsigned int p = lsum[hook(5, idx)] + lsum[hook(5, idx - 32)];
  sum4[hook(6, localID)] = (uint4)(p)-res;
}

kernel void prescanBottom(global unsigned int* restrict a, global unsigned int const* restrict sum, unsigned int m, unsigned int n) {
  size_t localID = get_local_id(0);
  size_t localWork = get_local_size(0);

  m >>= 2;
  global uint4* a4 = (global uint4*)a;
  local unsigned int lsum[256 + 256 / 2];

  size_t off = localWork / 2;
  size_t idx = localID + off;

  unsigned int offset = (localID == 0) ? sum[hook(1, get_group_id(0))] : 0;

  for (size_t count = 0; count < m; count += localWork, a4 += localWork) {
    if (localID < off)
      lsum[hook(5, localID)] = 0;

    uint4 val = a4[hook(4, localID)];
    lsum[hook(5, idx)] = offset + val.x + val.y + val.z + val.w;

    barrier(0x01);

    for (size_t d = 1; d < localWork; d <<= 1) {
      lsum[hook(5, idx)] += lsum[hook(5, idx - d)];
      barrier(0x01);
    }

    unsigned int p = (localID == 0) ? offset : lsum[hook(5, idx - 1)];
    uint4 result;
    result.x = p;
    p += val.x;
    result.y = p;
    p += val.y;
    result.z = p;
    p += val.z;
    result.w = p;
    a4[hook(4, localID)] = result;

    offset = (localID == 0) ? lsum[hook(5, localWork - 1)] : 0;
  }
}