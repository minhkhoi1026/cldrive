//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 1 | 0x20 | 2;
kernel void interpolation(read_only image2d_t in, write_only image2d_t out) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  float2 pos_norm = convert_float2(pos) / convert_float2(get_image_dim(out));

  float4 pix = read_imagef(in, sampler, pos_norm) * 255;

  write_imagef(out, pos, pix);
}