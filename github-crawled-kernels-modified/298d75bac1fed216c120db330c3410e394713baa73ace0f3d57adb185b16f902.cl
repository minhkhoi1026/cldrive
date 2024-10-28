//{"dest":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler_const = 0 | 0 | 0x10;
kernel void rgb2gray_unrolled(read_only image2d_t source, write_only image2d_t dest) {
  const int2 pixel_id = (int2)(get_global_id(0), get_global_id(1));
  const float4 rgba = read_imagef(source, sampler_const, pixel_id);
  const float gray = 0.2126 * rgba.x + 0.7152 * rgba.y + 0.0722 * rgba.z;
  write_imagef(dest, pixel_id, (float4)(gray, gray, gray, 1.0));
}