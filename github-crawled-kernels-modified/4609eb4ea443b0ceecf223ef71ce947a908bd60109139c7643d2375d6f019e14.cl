//{"arrayLength":4,"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"l_key":8,"l_val":9,"size":5,"sortDir":7,"stride":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ComparatorPrivate(unsigned int* keyA, unsigned int* valA, unsigned int* keyB, unsigned int* valB, unsigned int arrowDir) {
  if ((*keyA > *keyB) == arrowDir) {
    unsigned int t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

inline void ComparatorLocal(local unsigned int* keyA, local unsigned int* valA, local unsigned int* keyB, local unsigned int* valB, unsigned int arrowDir) {
  if ((*keyA > *keyB) == arrowDir) {
    unsigned int t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

kernel __attribute__((reqd_work_group_size(512U / 2, 1, 1))) void bitonicSortLocal(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal, unsigned int arrayLength, unsigned int sortDir) {
  local unsigned int l_key[512U];
  local unsigned int l_val[512U];

  d_SrcKey += get_group_id(0) * 512U + get_local_id(0);
  d_SrcVal += get_group_id(0) * 512U + get_local_id(0);
  d_DstKey += get_group_id(0) * 512U + get_local_id(0);
  d_DstVal += get_group_id(0) * 512U + get_local_id(0);
  l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[hook(2, 0)];
  l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[hook(3, 0)];
  l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
  l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

  for (unsigned int size = 2; size < arrayLength; size <<= 1) {
    unsigned int dir = ((get_local_id(0) & (size / 2)) != 0);
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)], &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)], dir);
    }
  }

  {
    for (unsigned int stride = arrayLength / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)], &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)], sortDir);
    }
  }

  barrier(0x01);
  d_DstKey[hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
  d_DstVal[hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
  d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
  d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}
kernel __attribute__((reqd_work_group_size(512U / 2, 1, 1))) void bitonicSortLocal1(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal) {
  local unsigned int l_key[512U];
  local unsigned int l_val[512U];

  d_SrcKey += get_group_id(0) * 512U + get_local_id(0);
  d_SrcVal += get_group_id(0) * 512U + get_local_id(0);
  d_DstKey += get_group_id(0) * 512U + get_local_id(0);
  d_DstVal += get_group_id(0) * 512U + get_local_id(0);
  l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[hook(2, 0)];
  l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[hook(3, 0)];
  l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
  l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

  unsigned int comparatorI = get_global_id(0) & ((512U / 2) - 1);

  for (unsigned int size = 2; size < 512U; size <<= 1) {
    unsigned int dir = (comparatorI & (size / 2)) != 0;
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)], &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)], dir);
    }
  }

  {
    unsigned int dir = (get_group_id(0) & 1);
    for (unsigned int stride = 512U / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)], &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)], dir);
    }
  }

  barrier(0x01);
  d_DstKey[hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
  d_DstVal[hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
  d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
  d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}

kernel void bitonicMergeGlobal(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal, unsigned int arrayLength, unsigned int size, unsigned int stride, unsigned int sortDir) {
  unsigned int global_comparatorI = get_global_id(0);
  unsigned int comparatorI = global_comparatorI & (arrayLength / 2 - 1);

  unsigned int dir = sortDir ^ ((comparatorI & (size / 2)) != 0);
  unsigned int pos = 2 * global_comparatorI - (global_comparatorI & (stride - 1));

  unsigned int keyA = d_SrcKey[hook(2, pos + 0)];
  unsigned int valA = d_SrcVal[hook(3, pos + 0)];
  unsigned int keyB = d_SrcKey[hook(2, pos + stride)];
  unsigned int valB = d_SrcVal[hook(3, pos + stride)];

  ComparatorPrivate(&keyA, &valA, &keyB, &valB, dir);

  d_DstKey[hook(0, pos + 0)] = keyA;
  d_DstVal[hook(1, pos + 0)] = valA;
  d_DstKey[hook(0, pos + stride)] = keyB;
  d_DstVal[hook(1, pos + stride)] = valB;
}