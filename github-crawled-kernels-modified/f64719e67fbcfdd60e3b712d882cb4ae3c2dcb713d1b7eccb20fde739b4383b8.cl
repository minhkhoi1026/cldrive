//{"destination":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void background_removal(read_only image2d_t source, write_only image2d_t destination) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  const float4 background_colour = (float4)(0xFF, 0x84, 0xD6, 0x5A);
  const unsigned int pixel = read_imageui(source, sampler, (int2)(x, y)).x;
  uint4 unpacked = (uint4)(((pixel >> 24) & 0x000000FF), ((pixel >> 16) & 0x000000FF), ((pixel >> 8) & 0x000000FF), ((pixel & 0x000000FF)));
  float4 unpacked_float = (float4)(unpacked.x, unpacked.y, unpacked.z, unpacked.w);

  float dissimilarity = length(background_colour - unpacked_float);
  if (dissimilarity > 80.0f) {
    write_imageui(destination, (int2)(x, y), pixel);
  }
}