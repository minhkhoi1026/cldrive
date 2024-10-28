//{"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"l_key":4,"l_val":5}
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

kernel void bitonicSortLocal1(global float* d_DstKey, global unsigned int* d_DstVal, global float* d_SrcKey, global unsigned int* d_SrcVal) {
  local float l_key[512U];
  local unsigned int l_val[512U];

  d_SrcKey += get_group_id(0) * 512U + get_local_id(0);
  d_SrcVal += get_group_id(0) * 512U + get_local_id(0);
  d_DstKey += get_group_id(0) * 512U + get_local_id(0);
  d_DstVal += get_group_id(0) * 512U + get_local_id(0);
  l_key[hook(4, get_local_id(0) + 0)] = d_SrcKey[hook(2, 0)];
  l_val[hook(5, get_local_id(0) + 0)] = d_SrcVal[hook(3, 0)];
  l_key[hook(4, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
  l_val[hook(5, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

  unsigned int comparatorI = get_global_id(0) & ((512U / 2) - 1);

  for (unsigned int size = 2; size < 512U; size <<= 1) {
    unsigned int ddd = (comparatorI & (size / 2)) != 0;
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(4, pos + 0)], &l_val[hook(5, pos + 0)], &l_key[hook(4, pos + stride)], &l_val[hook(5, pos + stride)], ddd);
    }
  }

  {
    unsigned int ddd = (get_group_id(0) & 1);
    for (unsigned int stride = 512U / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(4, pos + 0)], &l_val[hook(5, pos + 0)], &l_key[hook(4, pos + stride)], &l_val[hook(5, pos + stride)], ddd);
    }
  }

  barrier(0x01);
  d_DstKey[hook(0, 0)] = l_key[hook(4, get_local_id(0) + 0)];
  d_DstVal[hook(1, 0)] = l_val[hook(5, get_local_id(0) + 0)];
  d_DstKey[hook(0, (512U / 2))] = l_key[hook(4, get_local_id(0) + (512U / 2))];
  d_DstVal[hook(1, (512U / 2))] = l_val[hook(5, get_local_id(0) + (512U / 2))];
}