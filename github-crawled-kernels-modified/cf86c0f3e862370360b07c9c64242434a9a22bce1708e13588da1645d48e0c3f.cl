//{"bias":1,"input":0,"outputImage":2,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void channel_add(read_only image2d_t input, read_only image2d_t bias, write_only image2d_t outputImage, private const int w) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  const sampler_t sampler = 1 | 4 | 0x10;
  int2 coords;
  coords.x = x;
  coords.y = y;
  int2 coords_bias;
  coords_bias.x = x / w;
  coords_bias.y = 0;
  float4 in = read_imagef(input, sampler, coords);
  float4 biase = read_imagef(bias, sampler, coords_bias);
  float4 output = in + biase;
  write_imagef(outputImage, coords, output);
}