//{"_buf0":3,"count":0,"output":1,"output_idx":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_extrema_on_cpu_min(unsigned int count, global int* output, global unsigned int* output_idx, global int* _buf0) {
  unsigned int block = (unsigned int)ceil(((float)count) / get_global_size(0));
  unsigned int index = get_global_id(0) * block;
  unsigned int end = min(count, index + block);
  unsigned int value_index = index;
  int value = _buf0[hook(3, index)];
  index++;
  while (index < end) {
    int candidate = _buf0[hook(3, index)];

    bool compare = ((candidate) < (value));

    value = compare ? candidate : value;
    value_index = compare ? index : value_index;
    index++;
  }
  output[hook(1, get_global_id(0))] = value;
  output_idx[hook(2, get_global_id(0))] = value_index;
}