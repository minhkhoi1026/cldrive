//{"dest":1,"dst_step":3,"levels":4,"levels_local":6,"source":0,"src_step":2,"values":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar do_lut(uchar input, constant const unsigned int* levels, constant const unsigned int* values, int nb) {
  if (input < levels[hook(4, 0)])
    return input;

  if (input >= levels[hook(4, nb - 1)])
    return input;

  int k = 0;
  while (k < nb - 1 && input >= levels[hook(4, k + 1)])
    k++;

  return values[hook(5, k)];
}

uchar do_lut_linear(uchar input, constant const float* levels, constant const float* values, int nb) {
  if (input < levels[hook(4, 0)])
    return input;

  if (input >= levels[hook(4, nb - 1)])
    return input;

  int k = 0;
  while (k < nb - 1 && input > levels[hook(4, k)])
    k++;

  if (k > 0)
    k--;

  float DiffL = levels[hook(4, k + 1)] - levels[hook(4, k)];
  float DiffV = values[hook(5, k + 1)] - values[hook(5, k)];
  float Diff2 = input - levels[hook(4, k)];
  float Diff = Diff2 / DiffL * DiffV;

  return values[hook(5, k)] + Diff;
}

__attribute__((reqd_work_group_size(16, 16, 1))) kernel void lut_256_cached(global const uchar* source, global uchar* dest, int src_step, int dst_step, constant const uchar* levels) {
  const int gx = get_global_id(0) * 4;
  const int gy = get_global_id(1);
  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);

  const int lid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  local uchar levels_local[256];
  levels_local[hook(6, lid)] = levels[hook(4, lid)];
  barrier(0x01);

  for (int x = gx; x < gx + 4; x++)
    dest[hook(1, gy * dst_step + x)] = levels_local[hook(6, source[ghook(0, gy * src_step + x))];
}