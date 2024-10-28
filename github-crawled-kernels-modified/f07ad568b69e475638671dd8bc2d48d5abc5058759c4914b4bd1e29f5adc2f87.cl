//{"input":0,"input_size":1,"output":2,"scratch":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_int(global int* input, const unsigned int input_size, global int* output, local int* scratch) {
  const unsigned int gid = get_global_id(0);
  const unsigned int lid = get_local_id(0);
  const unsigned int values_per_thread = 8;
  const unsigned int index = gid * values_per_thread;
  if (index < input_size) {
    int sum = input[hook(0, index)];
    for (unsigned int i = 1; i < values_per_thread && (index + i) < input_size; i++) {
      sum = ((sum) * (input[hook(0, index + i)]));
    }
    scratch[hook(3, lid)] = sum;
  }
  for (unsigned int i = 1; i < get_local_size(0); i <<= 1) {
    barrier(0x01);
    unsigned int mask = (i << 1) - 1;
    unsigned int next_index = (gid + i) * values_per_thread;
    if ((lid & mask) == 0 && next_index < input_size) {
      scratch[hook(3, lid)] = ((scratch[hook(3, lid)]) * (scratch[hook(3, lid + i)]));
    }
  }
  if (lid == 0) {
    output[hook(2, get_group_id(0))] = scratch[hook(3, 0)];
  }
}