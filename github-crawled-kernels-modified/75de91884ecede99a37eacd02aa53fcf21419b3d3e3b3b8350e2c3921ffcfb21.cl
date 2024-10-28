//{"INHW":1,"data":4,"epsilon":2,"lcl_data":5,"lcl_mem":3,"varbuff":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ReduceKernel(local float* lcl_mem, unsigned int sum_stride, unsigned int unit_id, unsigned int unit_len) {
  float sum = 0;
  unsigned int lcl_offset = unit_id * unit_len;

  for (unsigned int i = 0; i < unit_len; i += sum_stride) {
    sum += lcl_mem[hook(3, lcl_offset + i)];
  }
  lcl_mem[hook(3, lcl_offset)] = sum;
}

inline void regLDSreduce(float* value, local float* data, unsigned int localID, float scale) {
  data[hook(4, localID)] = *value;
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
  *value = data[hook(4, 0)] * scale;
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
  *value = data[hook(4, localID)];
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x111, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x112, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x114, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x118, 0xF, 0xF, 0)), float);
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x142, 0xF, 0xF, 0)), float);
  *value += tmp;
  tmp = __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x143, 0xF, 0xF, 0)), float);
  *value += tmp;
  if (localID == 63)
    data[hook(4, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(4, 0)];
}

inline void dppLDSReduce16(float* value, local float* data, unsigned int localID, float scale) {
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x101, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x102, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x104, 0xF, 0xF, 0)), float);
  *value += __builtin_astype((__builtin_amdgcn_mov_dpp(__builtin_astype((*value), int), 0x108, 0xF, 0xF, 0)), float);
  if (localID == 0)
    data[hook(4, 0)] = *value * scale;
  barrier(0x01);
  *value = data[hook(4, 0)];
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void BatchNormFwdTrainSpatialFinalVariance(global float* restrict varbuff, float INHW

                                                                                                                                                ,
                                                                                                                                                double epsilon

) {
 private
  float variance = 0.;
 private
  float invVariance = 0.;

  unsigned int ylid = get_local_id(1);
  unsigned int ygrp_id = get_group_id(1);
  unsigned int xgid = get_global_id(0);
  unsigned int ygrp_sz = get_local_size(1);
  unsigned int yngrps = get_num_groups(1);
  unsigned int cidx = xgid * 1;
  unsigned int varstashindex = cidx + ygrp_sz * ygrp_id + 3;
  unsigned int commitID = 0;

  for (int gn = 0; gn < yngrps; gn++) {
    unsigned int offset = gn * ygrp_sz + ylid;
    unsigned int varindex = cidx + ygrp_sz * offset + 2;
    if (offset < yngrps) {
      variance += varbuff[hook(0, varindex)];
    }
  }
  commitID = 0;

  local float lcl_data[16];
  lcl_data[hook(5, ylid)] = variance;
  barrier(0x01);
  variance = 0.;
  for (int i = 0; i < 1; i++) {
    variance += lcl_data[hook(5, i)];
  }
  variance *= INHW;

  invVariance = rsqrt(variance + epsilon);
  if (ylid == commitID) {
    varbuff[hook(0, varstashindex)] = invVariance;
  }
}