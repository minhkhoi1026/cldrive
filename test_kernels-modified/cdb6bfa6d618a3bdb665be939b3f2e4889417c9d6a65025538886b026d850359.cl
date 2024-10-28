//{"byte_stream":0,"sub_hits":1,"subrange_length":3,"val_bot":5,"val_top":4,"word_length":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subrange_hits(global char* byte_stream, global unsigned int* sub_hits, const unsigned int word_length, const unsigned int subrange_length, const unsigned int val_top, const unsigned int val_bot) {
  const unsigned int id = get_global_id(0);
  unsigned int stop_offset = (id + 1) * subrange_length;
  unsigned int valid_values_count = 0;
  unsigned int value = 0;
  unsigned int i = 0, j = 0;

  for (i = id * subrange_length; i < stop_offset; i += word_length) {
    value = 0;
    for (j = 0; j < word_length; j++) {
      value <<= 8;
      value |= byte_stream[hook(0, i + j)];
    }

    if (value > val_bot && value < val_top)
      valid_values_count++;
  }

  sub_hits[hook(1, id)] = valid_values_count;
}