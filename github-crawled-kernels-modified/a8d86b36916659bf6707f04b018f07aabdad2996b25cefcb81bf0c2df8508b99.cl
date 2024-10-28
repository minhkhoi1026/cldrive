//{"array_size":2,"data_array":1,"do_shuffle":5,"index_array":0,"nthreads":3,"portion_size":4,"read_bench":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void infinity(global int* index_array, global int* data_array, unsigned long array_size, int nthreads, unsigned long portion_size, int do_shuffle, int read_bench) {
  size_t idx = get_global_id(0);
  int temp, garbage = 0;
  int i;
  int startof_portion, endof_portion;

  if (idx < nthreads) {
    if (do_shuffle) {
      startof_portion = idx * portion_size;
      endof_portion = startof_portion + portion_size;

      if (read_bench) {
        for (i = startof_portion; i < endof_portion; i++)
          temp = data_array[hook(1, index_array[ihook(0, i))];
        if (temp < 7)
          garbage++;
      } else {
        for (i = startof_portion; i < endof_portion; i++)
          data_array[hook(1, index_array[ihook(0, i))] = 1;
      }
    } else {
      if (read_bench) {
        for (i = 0; i <= (array_size - portion_size); i = i + portion_size)
          temp = data_array[hook(1, index_array[ihook(0, idx + i))];
        if (temp < 7)
          garbage++;
      } else {
        for (i = 0; i <= (array_size - portion_size); i = i + portion_size)
          data_array[hook(1, index_array[ihook(0, idx + i))] = 1;
      }
    }
  }
}