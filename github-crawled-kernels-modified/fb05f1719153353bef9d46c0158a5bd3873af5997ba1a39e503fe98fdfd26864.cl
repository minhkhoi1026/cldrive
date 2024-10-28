//{"filter":2,"in_image":0,"out_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void apply_filter(read_only image2d_t in_image, write_only image2d_t out_image, constant float* filter) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float4 sum = (float4)(0.0f);
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      sum.x += filter[hook(2, (y + 1) * 3 + (x + 1))] * read_imagef(in_image, sampler, pos + (int2)(x, y)).x;
      sum.y += filter[hook(2, (y + 1) * 3 + (x + 1))] * read_imagef(in_image, sampler, pos + (int2)(x, y)).y;
      sum.z += filter[hook(2, (y + 1) * 3 + (x + 1))] * read_imagef(in_image, sampler, pos + (int2)(x, y)).z;
    }
  }

  write_imagef(out_image, (int2)(pos.x, pos.y), sum);
}