//{"arrayLength":4,"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"dir":7,"size":5,"stride":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void ComparatorPrivate(unsigned int* keyA, unsigned int* valA, unsigned int* keyB, unsigned int* valB, unsigned int dir) {
  if ((*keyA > *keyB) == dir) {
    unsigned int t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

inline void ComparatorLocal(local unsigned int* keyA, local unsigned int* valA, local unsigned int* keyB, local unsigned int* valB, unsigned int dir) {
  if ((*keyA > *keyB) == dir) {
    unsigned int t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
    t = *valA;
    *valA = *valB;
    *valB = t;
  }
}

kernel void bitonicMergeGlobal(global unsigned int* d_DstKey, global unsigned int* d_DstVal, global unsigned int* d_SrcKey, global unsigned int* d_SrcVal, unsigned int arrayLength, unsigned int size, unsigned int stride, unsigned int dir) {
  unsigned int global_comparatorI = get_global_id(0);
  unsigned int comparatorI = global_comparatorI & (arrayLength / 2 - 1);

  unsigned int ddd = dir ^ ((comparatorI & (size / 2)) != 0);
  unsigned int pos = 2 * global_comparatorI - (global_comparatorI & (stride - 1));

  unsigned int keyA = d_SrcKey[hook(2, pos + 0)];
  unsigned int valA = d_SrcVal[hook(3, pos + 0)];
  unsigned int keyB = d_SrcKey[hook(2, pos + stride)];
  unsigned int valB = d_SrcVal[hook(3, pos + stride)];

  ComparatorPrivate(&keyA, &valA, &keyB, &valB, ddd);

  d_DstKey[hook(0, pos + 0)] = keyA;
  d_DstVal[hook(1, pos + 0)] = valA;
  d_DstKey[hook(0, pos + stride)] = keyB;
  d_DstVal[hook(1, pos + stride)] = valB;
}