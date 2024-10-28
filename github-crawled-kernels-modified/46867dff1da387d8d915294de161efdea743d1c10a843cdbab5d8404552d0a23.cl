//{"arrayLength":3,"d_DstKey":1,"d_SrcKey":2,"dist_buffer":0,"l_key":6,"size":4,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float sfrand_0_1(unsigned int* seed);
inline float sfrand_m1_1(unsigned int* seed);
inline float sfrand_0_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x3F800000;
  return (res - 1.0f);
}

inline float sfrand_m1_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x40000000;
  return (res - 3.0f);
}

inline void ComparatorPrivate(global const float* dist_buffer, unsigned int* keyA, unsigned int* keyB, unsigned int arrowDir) {
  const float dist_a = dist_buffer[hook(0, *keyA)];
  const float dist_b = dist_buffer[hook(0, *keyB)];
  if ((unsigned int)(dist_a < dist_b) == arrowDir) {
    unsigned int t = *keyA;
    *keyA = *keyB;
    *keyB = t;
  }
}

inline void ComparatorLocal(global const float* dist_buffer, local unsigned int* keyA, local unsigned int* keyB, unsigned int arrowDir) {
  const float dist_a = dist_buffer[hook(0, *keyA)];
  const float dist_b = dist_buffer[hook(0, *keyB)];
  if ((unsigned int)(dist_a < dist_b) == arrowDir) {
    unsigned int t = *keyA;
    *keyA = *keyB;
    *keyB = t;
  }
}
kernel __attribute__((reqd_work_group_size(1024 / 2, 1, 1))) void bitonicSortLocal(global const float* dist_buffer, global unsigned int* d_DstKey, global const unsigned int* d_SrcKey) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_group_id(0);

  if (get_global_id(0) >= get_global_size(0))
    return;

  local unsigned int l_key[1024];

  d_SrcKey += group_id * 1024 + local_id;
  d_DstKey += group_id * 1024 + local_id;
  l_key[hook(6, local_id + 0)] = d_SrcKey[hook(2, 0)];
  l_key[hook(6, local_id + (1024 / 2))] = d_SrcKey[hook(2, (1024 / 2))];

  unsigned int comparatorI = get_global_id(0) & ((1024 / 2) - 1);

  for (unsigned int size = 2; size < 1024; size <<= 1) {
    unsigned int dir = (comparatorI & (size / 2)) != 0;
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * local_id - (local_id & (stride - 1));
      ComparatorLocal(dist_buffer, &l_key[hook(6, pos + 0)], &l_key[hook(6, pos + stride)], dir);
    }
  }

  {
    unsigned int dir = (group_id & 1);
    for (unsigned int stride = 1024 / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * local_id - (local_id & (stride - 1));
      ComparatorLocal(dist_buffer, &l_key[hook(6, pos + 0)], &l_key[hook(6, pos + stride)], dir);
    }
  }

  barrier(0x01);
  d_DstKey[hook(1, 0)] = l_key[hook(6, local_id + 0)];
  d_DstKey[hook(1, (1024 / 2))] = l_key[hook(6, local_id + (1024 / 2))];
}

kernel void bitonicMergeGlobal(global const float* dist_buffer, global unsigned int* d_DstKey, global unsigned int* d_SrcKey, unsigned int arrayLength, unsigned int size, unsigned int stride) {
  unsigned int global_comparatorI = get_global_id(0);
  unsigned int comparatorI = global_comparatorI & (arrayLength / 2 - 1);
  if (global_comparatorI >= get_global_size(0))
    return;

  unsigned int dir = 1 ^ ((comparatorI & (size / 2)) != 0);
  unsigned int pos = 2 * global_comparatorI - (global_comparatorI & (stride - 1));

  unsigned int keyA = d_SrcKey[hook(2, pos + 0)];
  unsigned int keyB = d_SrcKey[hook(2, pos + stride)];

  ComparatorPrivate(dist_buffer, &keyA, &keyB, dir);

  d_DstKey[hook(1, pos + 0)] = keyA;
  d_DstKey[hook(1, pos + stride)] = keyB;
}