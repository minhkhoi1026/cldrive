//{"block":5,"count":2,"input":0,"offset":1,"output":3,"output_offset":4,"scratch":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global int* input, const unsigned int offset, const unsigned int count, global int* output, const unsigned int output_offset) {
  const unsigned int block_offset = get_group_id(0) * 8 * 12;
  global const int* block = input + offset + block_offset;
  const unsigned int lid = get_local_id(0);
  local int scratch[12];
  int sum = 0;
  for (unsigned int i = 0; i < 8; i++) {
    if (block_offset + lid + i * 12 < count) {
      sum = sum + block[hook(5, lid + i * 12)];
    }
  }
  scratch[hook(6, lid)] = sum;
  for (int i = 1; i < 12; i <<= 1) {
    barrier(0x01);
    unsigned int mask = (i << 1) - 1;
    if ((lid & mask) == 0) {
      scratch[hook(6, lid)] += scratch[hook(6, lid + i)];
    }
  }
  if (lid == 0) {
    output[hook(3, output_offset + get_group_id(0))] = scratch[hook(6, 0)];
  }
}