//{"blocks":2,"d_offsets":1,"d_prefixoffsets":0,"s_offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int addOffset(volatile local unsigned int* s_offset, unsigned int data, unsigned int threadTag) {
  unsigned int count;

  do {
    count = s_offset[hook(3, data)] & 0x07FFFFFFU;
    count = threadTag | (count + 1);
    s_offset[hook(3, data)] = count;
  } while (s_offset[hook(3, data)] != count);

  return (count & 0x07FFFFFFU) - 1;
}

kernel void bucketprefixoffset(global unsigned int* d_prefixoffsets, global unsigned int* d_offsets, const int blocks) {
  int tid = get_global_id(0);
  int size = blocks * ((1 << 10) * (1));
  int sum = 0;

  for (int i = tid; i < size; i += (1 << 10)) {
    int x = d_prefixoffsets[hook(0, i)];
    d_prefixoffsets[hook(0, i)] = sum;
    sum += x;
  }

  d_offsets[hook(1, tid)] = sum;
}