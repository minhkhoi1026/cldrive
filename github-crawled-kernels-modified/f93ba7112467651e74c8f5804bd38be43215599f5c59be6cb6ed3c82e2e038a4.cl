//{"matrix":0,"num_add_mean":1,"region_mean":3,"sum_add_mean":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int GlobalIndex(unsigned int x, unsigned int y, unsigned int z, unsigned int w, unsigned int h, unsigned int d) {
  return (z * (w * h)) + (y * w) + x;
}

kernel void Sum(global int* matrix, volatile global unsigned int* num_add_mean, volatile global unsigned int* sum_add_mean, global float* region_mean) {
  unsigned int g_x = get_global_id(0);
  unsigned int g_y = get_global_id(1);
  unsigned int g_z = get_global_id(2);
  unsigned int g_i = GlobalIndex(g_x, g_y, g_z, get_global_size(0), get_global_size(1), get_global_size(2));

  if (g_i == 0) {
    *num_add_mean = 0;
    *sum_add_mean = 0;
  }

  barrier(0x01 | 0x02);

  (void)atomic_inc(num_add_mean);
  (void)atomic_add(sum_add_mean, matrix[hook(0, g_i)]);

  barrier(0x01 | 0x02);

  if (g_i == (get_global_size(0) * get_global_size(1) * get_global_size(2)) - 1) {
    *region_mean = (float)(*sum_add_mean) / (float)(*num_add_mean);
  }
}