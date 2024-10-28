//{"arrayLength":4,"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"l_keyA":8,"l_valA":9,"size":5,"sortDir":7,"stride":6}
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

kernel __attribute__((reqd_work_group_size(32 / 2, 1, 1))) void bitonicSortLocal1(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal) {
  __attribute__((xcl_array_partition(complete, 1))) local unsigned int l_keyA[32];
  __attribute__((xcl_array_partition(complete, 1))) local unsigned int l_valA[32];

  async_work_group_copy(l_keyA, d_SrcKey + get_group_id(0) * 32, 32, 0);
  async_work_group_copy(l_valA, d_SrcVal + get_group_id(0) * 32, 32, 0);

  unsigned int comparatorI = get_global_id(0) & ((32 / 2) - 1);

  __attribute__((xcl_pipeline_loop)) for (unsigned int size = 2; size < 32; size <<= 1) {
    unsigned int dir = (comparatorI & (size / 2)) != 0;
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);

      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_keyA[hook(8, pos)], &l_valA[hook(9, pos)], &l_keyA[hook(8, pos + stride)], &l_valA[hook(9, pos + stride)], dir);
    }
  }

  unsigned int dir = (get_group_id(0) & 1);

  __attribute__((xcl_pipeline_loop)) for (unsigned int stride = 32 / 2; stride > 0; stride >>= 1) {
    barrier(0x01);

    unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));

    ComparatorLocal(&l_keyA[hook(8, pos)], &l_valA[hook(9, pos)], &l_keyA[hook(8, pos + stride)], &l_valA[hook(9, pos + stride)], dir);
  }

  async_work_group_copy(d_DstKey + get_group_id(0) * 32, l_keyA, 32, 0);
  async_work_group_copy(d_DstVal + get_group_id(0) * 32, l_valA, 32, 0);
}

kernel void bitonicMergeGlobal(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal, unsigned int arrayLength, unsigned int size, unsigned int stride, unsigned int sortDir) {
  __attribute__((xcl_pipeline_workitems)) {
    unsigned int global_comparatorI = get_global_id(0);
    unsigned int comparatorI = global_comparatorI & (arrayLength / 2 - 1);

    unsigned int dir = sortDir ^ ((comparatorI & (size / 2)) != 0);
    unsigned int pos = 2 * global_comparatorI - (global_comparatorI & (stride - 1));
    unsigned int keyA = d_SrcKey[hook(2, pos)];
    unsigned int valA = d_SrcVal[hook(3, pos)];
    unsigned int keyB = d_SrcKey[hook(2, pos + stride)];
    unsigned int valB = d_SrcVal[hook(3, pos + stride)];

    ComparatorPrivate(&keyA, &valA, &keyB, &valB, dir);

    d_DstKey[hook(0, pos)] = keyA;
    d_DstVal[hook(1, pos)] = valA;
    d_DstKey[hook(0, pos + stride)] = keyB;
    d_DstVal[hook(1, pos + stride)] = valB;
  }
}