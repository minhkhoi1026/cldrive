//{"img":0,"luminosity":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t format = 0 | 0x10 | 4;
float luminosity_from_color(const float4 col) {
  return 0.21f * col.x + 0.72f * col.y + 0.07f * col.z;
}

kernel void histogram_luminosity(read_only image2d_t img, global uchar* luminosity) {
  int2 d = (int2)(get_global_id(0), get_global_id(1));
  int l = get_global_id(0) + get_global_id(1) * get_global_size(0);
  float4 col = read_imagef(img, format, d);
  float lum = luminosity_from_color(col);
  luminosity[hook(1, l)] = convert_uchar_sat(min(lum, 1.0f) * 255.0f);
}