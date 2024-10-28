//{"g_data":0,"points_per_group":1,"scale":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_scale(global float2* g_data, unsigned int points_per_group, unsigned int scale) {
  unsigned int points_per_item, addr, i;
  points_per_item = points_per_group / get_local_size(0);
  addr = get_group_id(0) * points_per_group + get_local_id(0) * points_per_item;
  for (i = addr; i < addr + points_per_item; i++)
    g_data[hook(0, i)] /= scale;
}