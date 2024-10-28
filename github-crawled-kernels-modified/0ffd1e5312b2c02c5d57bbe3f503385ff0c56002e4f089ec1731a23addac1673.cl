//{"dest":1,"dst_step":3,"levels":5,"nb":7,"source":0,"src_step":2,"values":6,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar do_lut(uchar input, constant const unsigned int* levels, constant const unsigned int* values, int nb) {
  if (input < levels[hook(5, 0)])
    return input;

  if (input >= levels[hook(5, nb - 1)])
    return input;

  int k = 0;
  while (k < nb - 1 && input >= levels[hook(5, k + 1)])
    k++;

  return values[hook(6, k)];
}

uchar do_lut_linear(uchar input, constant const float* levels, constant const float* values, int nb) {
  if (input < levels[hook(5, 0)])
    return input;

  if (input >= levels[hook(5, nb - 1)])
    return input;

  int k = 0;
  while (k < nb - 1 && input > levels[hook(5, k)])
    k++;

  if (k > 0)
    k--;

  float DiffL = levels[hook(5, k + 1)] - levels[hook(5, k)];
  float DiffV = values[hook(6, k + 1)] - values[hook(6, k)];
  float Diff2 = input - levels[hook(5, k)];
  float Diff = Diff2 / DiffL * DiffV;

  return values[hook(6, k)] + Diff;
}

kernel void lut(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, constant const unsigned int* levels, constant const unsigned int* values, int nb) {
  const int gx = get_global_id(0) * 4;
  const int gy = get_global_id(1);
  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);

  if (4 > 1 && gx + 4 > width) {
    for (int x = gx; x < width; x++)
      dest[hook(1, gy * dst_step + x)] = do_lut(source[hook(0, gy * src_step + x)], levels, values, nb);

    return;
  }

  for (int x = gx; x < gx + 4; x++)
    dest[hook(1, gy * dst_step + x)] = do_lut(source[hook(0, gy * src_step + x)], levels, values, nb);
}