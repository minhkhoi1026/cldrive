//{"cache":5,"m":3,"num_cols":1,"num_elements_per_thread":2,"num_rows":0,"out":6,"v":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
kernel __attribute__((reqd_work_group_size(1, 256, 1))) kernel __attribute__((reqd_work_group_size(256, 1, 1))) kernel void TransposedMatVecMul(unsigned int num_rows, unsigned int num_cols, unsigned int num_elements_per_thread, global const float* m, global const float* v, local float* cache, global float* out) {
  unsigned int base_row = get_global_id(1) * num_elements_per_thread;
  unsigned int col = get_global_id(0);

  for (unsigned int i = 0; i < num_elements_per_thread; i += get_local_size(0)) {
    unsigned int row = i + get_local_id(0);
    if (row < num_elements_per_thread) {
      if (base_row + row < num_rows)
        cache[hook(5, row)] = v[hook(4, base_row + row)];
      else
        cache[hook(5, row)] = 0;
    }
  }

  barrier(0x01);

  float sum = 0;

  for (unsigned int i = 0; i < num_elements_per_thread; i++)
    if (base_row + i < num_rows && col < num_cols)

      sum += m[hook(3, (base_row + i) * num_cols + col)] * cache[hook(5, i)];

  if (col < num_cols)
    out[hook(6, col * get_global_size(1) + get_global_id(1))] = sum;
}