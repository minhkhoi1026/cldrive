//{"bias":3,"data":5,"in":0,"lcl_mem":4,"out":1,"scale":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ReduceKernel(local float* lcl_mem, unsigned int sum_stride, unsigned int unit_id, unsigned int unit_len) {
  float sum = 0;
  unsigned int lcl_offset = unit_id * unit_len;

  for (unsigned int i = 0; i < unit_len; i += sum_stride) {
    sum += lcl_mem[hook(4, lcl_offset + i)];
  }
  lcl_mem[hook(4, lcl_offset)] = sum;
}

inline void regLDSreduce(float* value, local float* data, unsigned int localID, float scale) {
  data[hook(5, localID)] = *value;
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
  *value = data[hook(5, 0)] * scale;
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
  *value = data[hook(5, localID)];
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x111, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x112, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x114, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x118, 0xF, 0xF, 0)), float);
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x142, 0xF, 0xF, 0)), float);
  *value += tmp;
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x143, 0xF, 0xF, 0)), float);
  *value += tmp;
  if (localID == 63)
    data[hook(5, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(5, 0)];
}

inline void dppLDSReduce16(float* value, local float* data, unsigned int localID, float scale) {
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x101, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x102, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x104, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x108, 0xF, 0xF, 0)), float);
  if (localID == 0)
    data[hook(5, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(5, 0)];
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void BatchNormFwdTrainSpatialNorm(const global float* restrict in, global float* restrict out, const global float* restrict scale, const global float* restrict bias) {
  float mean = 0.;
  float invVariance = 0.;
  float inhat = 0.;
  float pvt_scale = 0.;
  float pvt_bias = 0.;

  local float lcl_mean, lcl_ivar, lcl_scale, lcl_bias;

  unsigned int ygrp_id = get_group_id(1);
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);
  unsigned int ygrp_sz = get_local_size(1);
  unsigned int index;
  unsigned int cidx = xgid * 1;
  unsigned int meanstashindex = cidx + ygrp_sz * ygrp_id + 1;
  unsigned int varstashindex = cidx + ygrp_sz * ygrp_id + 3;

  if (get_local_id(1) == 0) {
    lcl_scale = scale[hook(2, xgid)];
    lcl_bias = bias[hook(3, xgid)];
    lcl_mean = out[hook(1, meanstashindex)];
    lcl_ivar = out[hook(1, varstashindex)];
  }
  barrier(0x01);

  if (ygid < 1) {
    mean = lcl_mean;
    invVariance = lcl_ivar;
    pvt_scale = lcl_scale;
    pvt_bias = lcl_bias;
    for (unsigned int n = 0; n < 1; n++) {
      index = n * 1 + cidx + ygid;
      inhat = (in[hook(0, index)] - mean) * invVariance;

      out[hook(1, index)] = mad(pvt_scale, inhat, pvt_bias);
    }
  }
}