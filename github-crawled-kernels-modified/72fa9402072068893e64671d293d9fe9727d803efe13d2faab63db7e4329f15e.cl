//{"data.array":1,"global_data":0,"mask.array":3,"ones.array":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void radix_sort8(global ushort8* global_data) {
  typedef union {
    ushort8 vec;
    ushort array[8];
  } vec_array;

  unsigned int one_count, zero_count;
  unsigned int cmp_value = 1;
  vec_array mask, ones, data;

  data.vec = global_data[hook(0, 0)];

  for (int i = 0; i < 3; i++) {
    zero_count = 0;
    one_count = 0;

    for (int j = 0; j < 8; j++) {
      if (data.array[hook(1, j)] & cmp_value)
        ones.array[hook(2, one_count++)] = data.array[hook(1, j)];
      else
        mask.array[hook(3, zero_count++)] = j;
    }

    for (int j = zero_count; j < 8; j++)
      mask.array[hook(3, j)] = 8 - zero_count + j;
    data.vec = shuffle2(data.vec, ones.vec, mask.vec);
    cmp_value <<= 1;
  }
  global_data[hook(0, 0)] = data.vec;
}