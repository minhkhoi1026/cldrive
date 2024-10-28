//{"addition_array":1,"data":0,"read_offset":3,"read_size":2,"write_offset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void parallelReduction(global float* data, local float* addition_array, unsigned int read_size, unsigned int read_offset, unsigned int write_offset) {
  int N = get_local_size(0);

  if (get_global_id(0) < read_size) {
    addition_array[hook(1, get_local_id(0))] = data[hook(0, get_global_id(0) + read_offset)];
  } else {
    addition_array[hook(1, get_local_id(0))] = 0.0f;
  }

  barrier(0x01);

  for (unsigned int i = N / 2; i > 0; i >>= 1) {
    if (get_local_id(0) < i) {
      addition_array[hook(1, get_local_id(0))] += addition_array[hook(1, i + get_local_id(0))];
    }

    barrier(0x01);
  }

  if (get_local_id(0) == 0) {
    data[hook(0, write_offset + get_group_id(0))] = addition_array[hook(1, 0)];
  }
}