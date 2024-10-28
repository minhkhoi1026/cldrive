//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 0 | 0x10;
kernel void filter(read_only image2d_t in, write_only image2d_t out) {
  size_t x = get_global_id(0) + 1;
  size_t y = get_global_id(1) + 1;

  float4 data = (float4)0.0f;
  for (int yy = 0; yy < 3; yy++)
    for (int xx = 0; xx < 3; xx++) {
      int2 coord = (int2)((x - 1 + xx), (y - 1 + yy));
      if (yy == 1 && xx == 1)
        data += (read_imagef(in, samp, coord) * 8.0f);
      else
        data -= read_imagef(in, samp, coord);
    }

  data.w = 1.0f;

  write_imagef(out, (int2)(x, y), data);
}