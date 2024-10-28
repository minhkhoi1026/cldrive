//{"d_prefixoffsets":2,"indice":1,"input":0,"l_pivotpoints":4,"s_offset":6,"size":3,"totalnum":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int addOffset(volatile local unsigned int* s_offset, unsigned int data, unsigned int threadTag) {
  unsigned int count;

  do {
    count = s_offset[hook(6, data)] & 0x07FFFFFFU;
    count = threadTag | (count + 1);
    s_offset[hook(6, data)] = count;
  } while (s_offset[hook(6, data)] != count);

  return (count & 0x07FFFFFFU) - 1;
}

kernel void bucketcount(global float* input, global int* indice, global unsigned int* d_prefixoffsets, const int size, global float* l_pivotpoints, int totalnum) {
  volatile local unsigned int s_offset[((1 << 10) * (1))];

  const unsigned int threadTag = get_local_id(0) << (32 - (5));
  const int warpBase = (get_local_id(0) >> (5)) * (1 << 10);
  const int numThreads = totalnum;

  for (int i = get_local_id(0); i < ((1 << 10) * (1)); i += get_local_size(0))
    s_offset[hook(6, i)] = 0;

  barrier(0x01 | 0x02);

  for (int tid = get_global_id(0); tid < size; tid += numThreads) {
    float elem = input[hook(0, tid)];

    int idx = (1 << 10) / 2 - 1;
    int jump = (1 << 10) / 4;
    float piv = l_pivotpoints[hook(4, idx)];

    while (jump >= 1) {
      idx = (elem < piv) ? (idx - jump) : (idx + jump);
      piv = l_pivotpoints[hook(4, idx)];
      jump /= 2;
    }
    idx = (elem < piv) ? idx : (idx + 1);

    indice[hook(1, tid)] = (addOffset(s_offset + warpBase, idx, threadTag) << (10)) + idx;
  }

  barrier(0x01 | 0x02);

  int prefixBase = get_global_id(0) / get_local_size(0) * ((1 << 10) * (1));

  for (int i = get_local_id(0); i < ((1 << 10) * (1)); i += get_local_size(0))
    d_prefixoffsets[hook(2, prefixBase + i)] = s_offset[hook(6, i)] & 0x07FFFFFFU;
}