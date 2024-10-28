//{"_buf0":2,"_buf1":3,"count":0,"output":1,"scratch":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initial_reduce(const unsigned int count, global int* output, global int* _buf0, global int* _buf1) {
  const unsigned int offset = get_group_id(0) * 8 * 8;
  const unsigned int lid = get_local_id(0);
  local int scratch[8];
  int sum = 0;
  for (unsigned int i = 0; i < 8; i++) {
    if (offset + lid + i * 8 < count) {
      sum = sum + ((_buf0[hook(2, offset + lid + i * 8)]) * (_buf1[hook(3, offset + lid + i * 8)]));
    }
  }
  scratch[hook(4, lid)] = sum;
  for (int i = 1; i < 8; i <<= 1) {
    barrier(0x01);
    unsigned int mask = (i << 1) - 1;
    if ((lid & mask) == 0) {
      scratch[hook(4, lid)] += scratch[hook(4, lid + i)];
    }
  }
  if (lid == 0) {
    output[hook(1, get_group_id(0))] = scratch[hook(4, 0)];
  }
}