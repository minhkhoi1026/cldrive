//{"in_image":0,"out_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void image_copy(read_only image2d_t in_image, write_only image2d_t out_image) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  float4 sum = (float4)(0.0f);

  for (int y = -3; y <= 3; y++) {
    for (int x = -3; x <= 3; x++) {
      sum += read_imagef(in_image, sampler, pos + (int2)(x, y));
    }
  }

  write_imagef(out_image, (int2)(pos.x, pos.y), sum);
}