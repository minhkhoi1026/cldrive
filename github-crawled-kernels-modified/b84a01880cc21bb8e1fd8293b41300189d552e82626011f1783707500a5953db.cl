//{"dest":4,"in_sums":0,"inout_array":1,"numElems":2,"shmem":5,"source":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 make_int4(int x, int y, int z, int w) {
  int4 res;
  res.x = x;
  res.y = y;
  res.z = z;
  res.w = w;
  return res;
}
float4 make_float4(float x, float y, float z, float w) {
  float4 res;
  res.x = x;
  res.y = y;
  res.z = z;
  res.w = w;
  return res;
}

int4 safe_load_int4(global int4* source, unsigned int idx, unsigned int sizeInTypeUnits) {
  int4 res = make_int4(0, 0, 0, 0);
  if (((idx + 1) << 2) <= sizeInTypeUnits)
    res = source[hook(3, idx)];
  else {
    if ((idx << 2) < sizeInTypeUnits)
      res.x = source[hook(3, idx)].x;
    if ((idx << 2) + 1 < sizeInTypeUnits)
      res.y = source[hook(3, idx)].y;
    if ((idx << 2) + 2 < sizeInTypeUnits)
      res.z = source[hook(3, idx)].z;
  }
  return res;
}
float4 safe_load_float4(global float4* source, unsigned int idx, unsigned int sizeInTypeUnits) {
  float4 res = make_float4(0, 0, 0, 0);
  if (((idx + 1) << 2) <= sizeInTypeUnits)
    res = source[hook(3, idx)];
  else {
    if ((idx << 2) < sizeInTypeUnits)
      res.x = source[hook(3, idx)].x;
    if ((idx << 2) + 1 < sizeInTypeUnits)
      res.y = source[hook(3, idx)].y;
    if ((idx << 2) + 2 < sizeInTypeUnits)
      res.z = source[hook(3, idx)].z;
  }
  return res;
}

void safe_store_int4(int4 val, global int4* dest, unsigned int idx, unsigned int sizeInTypeUnits) {
  if ((idx + 1) * 4 <= sizeInTypeUnits)
    dest[hook(4, idx)] = val;
  else {
    if (idx * 4 < sizeInTypeUnits)
      dest[hook(4, idx)].x = val.x;
    if (idx * 4 + 1 < sizeInTypeUnits)
      dest[hook(4, idx)].y = val.y;
    if (idx * 4 + 2 < sizeInTypeUnits)
      dest[hook(4, idx)].z = val.z;
  }
}
void safe_store_float4(float4 val, global float4* dest, unsigned int idx, unsigned int sizeInTypeUnits) {
  if ((idx + 1) * 4 <= sizeInTypeUnits)
    dest[hook(4, idx)] = val;
  else {
    if (idx * 4 < sizeInTypeUnits)
      dest[hook(4, idx)].x = val.x;
    if (idx * 4 + 1 < sizeInTypeUnits)
      dest[hook(4, idx)].y = val.y;
    if (idx * 4 + 2 < sizeInTypeUnits)
      dest[hook(4, idx)].z = val.z;
  }
}

void group_scan_exclusive_int(int localId, int groupSize, local int* shmem) {
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0)
    shmem[hook(5, groupSize - 1)] = 0;
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      int temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
}
void group_scan_exclusive_uint(int localId, int groupSize, local unsigned int* shmem) {
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0)
    shmem[hook(5, groupSize - 1)] = 0;
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      unsigned int temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
}
void group_scan_exclusive_float(int localId, int groupSize, local float* shmem) {
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0)
    shmem[hook(5, groupSize - 1)] = 0;
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      float temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
}
void group_scan_exclusive_short(int localId, int groupSize, local short* shmem) {
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0)
    shmem[hook(5, groupSize - 1)] = 0;
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      short temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
}

void group_scan_exclusive_sum_uint(int localId, int groupSize, local unsigned int* shmem, unsigned int* sum) {
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  *sum = shmem[hook(5, groupSize - 1)];
  barrier(0x01);
  if (localId == 0) {
    shmem[hook(5, groupSize - 1)] = 0;
  }
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      unsigned int temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
}

int group_scan_exclusive_part_int(int localId, int groupSize, local int* shmem) {
  int sum = 0;
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0) {
    sum = shmem[hook(5, groupSize - 1)];
    shmem[hook(5, groupSize - 1)] = 0;
  }
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      int temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
  return sum;
}
float group_scan_exclusive_part_float(int localId, int groupSize, local float* shmem) {
  float sum = 0;
  for (int stride = 1; stride <= (groupSize >> 1); stride <<= 1) {
    if (localId < groupSize / (2 * stride)) {
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + shmem[hook(5, (2 * localId + 1) * stride - 1)];
    }
    barrier(0x01);
  }
  if (localId == 0) {
    sum = shmem[hook(5, groupSize - 1)];
    shmem[hook(5, groupSize - 1)] = 0;
  }
  barrier(0x01);
  for (int stride = (groupSize >> 1); stride > 0; stride >>= 1) {
    if (localId < groupSize / (2 * stride)) {
      float temp = shmem[hook(5, (2 * localId + 1) * stride - 1)];
      shmem[hook(5, (2 * localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)];
      shmem[hook(5, 2 * (localId + 1) * stride - 1)] = shmem[hook(5, 2 * (localId + 1) * stride - 1)] + temp;
    }
    barrier(0x01);
  }
  return sum;
}

__attribute__((reqd_work_group_size(64, 1, 1))) __attribute__((reqd_work_group_size(64, 1, 1))) __attribute__((reqd_work_group_size(64, 1, 1))) __attribute__((reqd_work_group_size(64, 1, 1))) kernel void distribute_part_sum_float4(global float* in_sums, global float4* inout_array, unsigned int numElems) {
  int globalId = get_global_id(0);
  int groupId = get_group_id(0);
  float4 v1 = safe_load_float4(inout_array, globalId, numElems);
  float sum = in_sums[hook(0, groupId >> 1)];
  v1.xyzw += sum;
  safe_store_float4(v1, inout_array, globalId, numElems);
}