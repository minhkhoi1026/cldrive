//{"array":0,"fused":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

kernel void fuse_level(read_only image2d_array_t array, write_only image2d_t fused) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int depth = get_image_array_size(array);

  float4 acc = 0.0f;
  float weight_sum = 0.0f;

  for (int i = 0; i < depth; ++i) {
    int4 array_coord = (int4)(coord.x, coord.y, i, 0);
    float4 pix = read_imagef(array, g_sampler, array_coord);

    weight_sum += pix.s3;

    pix *= pix.s3;

    acc += pix;
  }

  acc /= weight_sum;

  write_imagef(fused, coord, acc);
}