//{"corner":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float gray(float4 v) {
  return 0.299f * v.x + 0.587f * v.y + 0.114f * v.z;
}

kernel void cornerness_suppress(read_only image2d_t corner, write_only image2d_t out) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float corner_v = read_imagef(corner, sampler, (int2)(x, y)).x;

  bool maximal = true;
  for (int yy = -1; yy <= 1; yy++)
    for (int xx = -1; xx <= 1; xx++)
      if (read_imagef(corner, sampler, (int2)(x + xx, y + yy)).x > corner_v)
        maximal = false;

  write_imagef(out, (int2)(x, y), (maximal) ? 1.0f : 0.0f);
}