//{"d_prefixoffsets":4,"indice":1,"input":0,"l_offsets":5,"output":2,"s_offset":7,"size":3,"totalnum":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int addOffset(volatile local unsigned int* s_offset, unsigned int data, unsigned int threadTag) {
  unsigned int count;

  do {
    count = s_offset[hook(7, data)] & 0x07FFFFFFU;
    count = threadTag | (count + 1);
    s_offset[hook(7, data)] = count;
  } while (s_offset[hook(7, data)] != count);

  return (count & 0x07FFFFFFU) - 1;
}

kernel void bucketsort(global float* input, global int* indice, global float* output, const int size, global unsigned int* d_prefixoffsets, global unsigned int* l_offsets, int totalnum) {
  volatile local unsigned int s_offset[((1 << 10) * (1))];

  int prefixBase = get_global_id(0) / get_local_size(0) * ((1 << 10) * (1));

  const int warpBase = (get_local_id(0) >> (5)) * (1 << 10);
  const int numThreads = totalnum;

  for (int i = get_local_id(0); i < ((1 << 10) * (1)); i += get_local_size(0)) {
    s_offset[hook(7, i)] = l_offsets[hook(5, i & ((1 << 10) - 1))] + d_prefixoffsets[hook(4, prefixBase + i)];
  }

  barrier(0x01 | 0x02);

  for (int tid = get_global_id(0); tid < size; tid += numThreads) {
    float elem = input[hook(0, tid)];
    int id = indice[hook(1, tid)];
    output[hook(2, s_offset[whook(7, warpBase + (id & ((1 << 10) - 1))) + (id >> (10)))] = elem;
    int test = s_offset[hook(7, warpBase + (id & ((1 << 10) - 1)))] + (id >> (10));
  }
}