//{"arrayLength":4,"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"dir":7,"l_key":8,"l_val":9,"size":6,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ComparatorPrivate(float* keyA, unsigned int* valA, float* keyB, unsigned int* valB, unsigned int dir) {
  if ((*keyA > *keyB) == dir) {
    float t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

inline void ComparatorLocal(local float* keyA, local unsigned int* valA, local float* keyB, local unsigned int* valB, unsigned int dir) {
  if ((*keyA > *keyB) == dir) {
    float t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

kernel void bitonicMergeLocal(global float* d_DstKey, global unsigned int* d_DstVal, global float* d_SrcKey, global unsigned int* d_SrcVal, unsigned int arrayLength, unsigned int stride, unsigned int size, unsigned int dir) {
  local float l_key[512U];
  local unsigned int l_val[512U];

  d_SrcKey += get_group_id(0) * 512U + get_local_id(0);
  d_SrcVal += get_group_id(0) * 512U + get_local_id(0);
  d_DstKey += get_group_id(0) * 512U + get_local_id(0);
  d_DstVal += get_group_id(0) * 512U + get_local_id(0);
  l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[hook(2, 0)];
  l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[hook(3, 0)];
  l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
  l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

  unsigned int comparatorI = get_global_id(0) & ((arrayLength / 2) - 1);
  unsigned int ddd = dir ^ ((comparatorI & (size / 2)) != 0);
  for (; stride > 0; stride >>= 1) {
    barrier(0x01);
    unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
    ComparatorLocal(&l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)], &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)], ddd);
  }

  barrier(0x01);
  d_DstKey[hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
  d_DstVal[hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
  d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
  d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}