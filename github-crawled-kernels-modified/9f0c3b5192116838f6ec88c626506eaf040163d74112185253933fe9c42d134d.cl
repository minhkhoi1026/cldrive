//{"cache":5,"m":3,"num_cols":1,"num_elements_per_thread":2,"num_rows":0,"out":6,"v":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
kernel __attribute__((reqd_work_group_size(1, 256, 1))) kernel void MatVecMul(unsigned int num_rows, unsigned int num_cols, unsigned int num_elements_per_thread, global const float* m, global const float* v, local float* cache, global float* out) {
  unsigned int base_col = get_global_id(0) * num_elements_per_thread;
  unsigned int row = get_global_id(1);

  for (unsigned int i = 0; i < num_elements_per_thread; i += get_local_size(1)) {
    unsigned int col = i + get_local_id(1);
    if (col < num_elements_per_thread) {
      if (base_col + col < num_cols)
        cache[hook(5, col)] = v[hook(4, base_col + col)];
      else
        cache[hook(5, col)] = 0;
    }
  }

  barrier(0x01);

  float sum = 0;

  for (unsigned int i = 0; i < num_elements_per_thread; i++)
    if (base_col + i < num_cols && row < num_rows)
      sum += m[hook(3, row * num_cols + base_col + i)] * cache[hook(5, i)];

  if (row < num_rows)
    out[hook(6, row * get_global_size(0) + get_global_id(0))] = sum;
}