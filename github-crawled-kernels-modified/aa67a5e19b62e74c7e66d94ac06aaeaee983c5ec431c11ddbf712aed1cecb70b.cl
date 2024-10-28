//{"dest":6,"in_array":0,"numElems":2,"out_array":1,"out_sums":3,"shmem":4,"source":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 safe_load_int4(global int4 const* source, unsigned int idx, unsigned int sizeInTypeUnits) {
  int4 res = (int4)(0, 0, 0, 0);
  if (((idx + 1) << 2) <= sizeInTypeUnits)
    res = source[hook(5, idx)];
  else {
    if ((idx << 2) < sizeInTypeUnits)
      res.x = source[hook(5, idx)].x;
    if ((idx << 2) + 1 < sizeInTypeUnits)
      res.y = source[hook(5, idx)].y;
    if ((idx << 2) + 2 < sizeInTypeUnits)
      res.z = source[hook(5, idx)].z;
  }
  return res;
}
void safe_store_int4(int4 val, global int4* dest, unsigned int idx, unsigned int sizeInTypeUnits) {
  if ((idx + 1) * 4 <= sizeInTypeUnits)
    dest[hook(6, idx)] = val;
  else {
    if (idx * 4 < sizeInTypeUnits)
      dest[hook(6, idx)].x = val.x;
    if (idx * 4 + 1 < sizeInTypeUnits)
      dest[hook(6, idx)].y = val.y;
    if (idx * 4 + 2 < sizeInTypeUnits)
      dest[hook(6, idx)].z = val.z;
  }
}
int group_scan_exclusive_part_int(int localId, int groupSize, local int* shmem) {
  int sum = 0;
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(4, 2 * (localId + 1) * stride - 1)] = shmem[hook(4, 2 * (localId + 1) * stride - 1)] + shmem[hook(4, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0) {
    sum = shmem[hook(4, groupSize - 1)];
    shmem[hook(4, groupSize - 1)] = 0;
  }
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      int temp = shmem[hook(4, (2 * localId + 1) * stride - 1)];
      shmem[hook(4, (2 * localId + 1) * stride - 1)] = shmem[hook(4, 2 * (localId + 1) * stride - 1)];
      shmem[hook(4, 2 * (localId + 1) * stride - 1)] = shmem[hook(4, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
  return sum;
}
__attribute__((reqd_work_group_size(64, 1, 1))) kernel void scan_exclusive_part_int4(global int4 const* in_array, global int4* out_array, unsigned int numElems, global int* out_sums, local int* shmem) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);
  int groupId = get_group_id(0);
  int groupSize = get_local_size(0);
  int4 v1 = safe_load_int4(in_array, 2 * globalId, numElems);
  int4 v2 = safe_load_int4(in_array, 2 * globalId + 1, numElems);
  v1.y += v1.x;
  v1.w += v1.z;
  v1.w += v1.y;
  v2.y += v2.x;
  v2.w += v2.z;
  v2.w += v2.y;
  v2.w += v1.w;
  shmem[hook(4, localId)] = v2.w;
  barrier(0x01);
  int sum = group_scan_exclusive_part_int(localId, groupSize, shmem);
  if (localId == 0)
    out_sums[hook(3, groupId)] = sum;
  v2.w = shmem[hook(4, localId)];
  int t = v1.w;
  v1.w = v2.w;
  v2.w += t;
  t = v1.y;
  v1.y = v1.w;
  v1.w += t;
  t = v2.y;
  v2.y = v2.w;
  v2.w += t;
  t = v1.x;
  v1.x = v1.y;
  v1.y += t;
  t = v2.x;
  v2.x = v2.y;
  v2.y += t;
  t = v1.z;
  v1.z = v1.w;
  v1.w += t;
  t = v2.z;
  v2.z = v2.w;
  v2.w += t;
  safe_store_int4(v2, out_array, 2 * globalId + 1, numElems);
  safe_store_int4(v1, out_array, 2 * globalId, numElems);
}