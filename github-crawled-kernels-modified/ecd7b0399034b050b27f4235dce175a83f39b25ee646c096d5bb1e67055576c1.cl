//{"data":3,"in":0,"lcl_data":4,"lcl_mem":2,"meanvarbuff":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ReduceKernel(local float* lcl_mem, unsigned int sum_stride, unsigned int unit_id, unsigned int unit_len) {
  float sum = 0;
  unsigned int lcl_offset = unit_id * unit_len;

  for (unsigned int i = 0; i < unit_len; i += sum_stride) {
    sum += lcl_mem[hook(2, lcl_offset + i)];
  }
  lcl_mem[hook(2, lcl_offset)] = sum;
}

inline void regLDSreduce(float* value, local float* data, unsigned int localID, float scale) {
  data[hook(3, localID)] = *value;
  barrier(0x01);
  if (localID < (256 >> 2))
    ReduceKernel(data, 1, localID, 4);
  barrier(0x01);
  if (localID < (256 >> 4))
    ReduceKernel(data, 4, localID, 16);
  barrier(0x01);
  if (localID == 0)
    ReduceKernel(data, 16, localID, 256);
  barrier(0x01);
  *value = data[hook(3, 0)] * scale;
}

inline void dppRegReduce64(float* value, float scale) {
  float tmp = 0.;
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x111, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x112, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x114, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x118, 0xF, 0xF, 0)), float);
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x142, 0xF, 0xF, 0)), float);
  *value += tmp;
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x143, 0xF, 0xF, 0)), float);
  *value += tmp;
  *value = __builtin_astype((__builtin_amdgcn_readlane(__builtin_astype((*value), int), 63)), float);
  *value *= scale;
}

inline void dppRegReduce16(float* value, float scale) {
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x101, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x102, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x104, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x108, 0xF, 0xF, 0)), float);
  *value = __builtin_astype((__builtin_amdgcn_readlane(__builtin_astype((*value), int), 0)), float);
  *value *= scale;
}

inline void dppLDSReduce64(float* value, local float* data, unsigned int localID, float scale) {
  float tmp = 0.;
  *value = data[hook(3, localID)];
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x111, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x112, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x114, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x118, 0xF, 0xF, 0)), float);
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x142, 0xF, 0xF, 0)), float);
  *value += tmp;
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x143, 0xF, 0xF, 0)), float);
  *value += tmp;
  if (localID == 63)
    data[hook(3, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(3, 0)];
}

inline void dppLDSReduce16(float* value, local float* data, unsigned int localID, float scale) {
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x101, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x102, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x104, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x108, 0xF, 0xF, 0)), float);
  if (localID == 0)
    data[hook(3, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(3, 0)];
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void BatchNormFwdTrainSpatialVariance(const global float* restrict in, global float* restrict meanvarbuff) {
  float variance = 0.;
  float mean, elemStd;

  local float lcl_data[256];
  local float lcl_mean;
  unsigned int ylid = get_local_id(1);
  unsigned int ygrp_id = get_group_id(1);
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);
  unsigned int ygrp_sz = get_local_size(1);
  unsigned int cidx = xgid * 1;
  unsigned int index;

  unsigned int meanstashindex = cidx + ygrp_sz * ygrp_id + 1;

  if (ylid == 0) {
    lcl_mean = meanvarbuff[hook(1, meanstashindex)];
  }
  barrier(0x01);

  if (ygid < 1) {
    mean = lcl_mean;
    for (unsigned int n = 0; n < 1; n++) {
      index = n * 1 + cidx + ygid;
      elemStd = (in[hook(0, index)] - mean);
      variance += elemStd * elemStd;
    }
  }

  lcl_data[hook(4, ylid)] = variance;
  barrier(0x01);
  for (unsigned int red = (1 >> 1); red > 256; red >>= 1) {
    if (ylid < red)
      lcl_data[hook(4, ylid)] += lcl_data[hook(4, ylid + red)];
    barrier(0x01);
  }
  regLDSreduce(&variance, lcl_data, ylid, 1);

  if (ylid == 0) {
    unsigned int varindex = cidx + ygrp_sz * ygrp_id + 2;
    meanvarbuff[hook(1, varindex)] = variance;
  }
}