//{"blurry":1,"detail_thresh":3,"in":0,"out":2,"sharpen":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void unsharped_mask(read_only image2d_t in, read_only image2d_t blurry, write_only image2d_t out, float detail_thresh, float sharpen) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 in_v = read_imagef(in, sampler, (int2)(x, y));

  float4 detail = read_imagef(blurry, sampler, (int2)(x, y)) - in_v;

  float4 sharpened = sharpen * copysign(fmax(fabs(detail) - detail_thresh, 0.0f), detail) * convert_float4(detail > detail_thresh);

  write_imagef(out, (int2)(x, y), in_v + sharpened);
}