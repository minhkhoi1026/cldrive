//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void video_image(read_only image2d_t in, write_only image2d_t out) {
  const sampler_t format = 0 | 0x10 | 4;
  const int2 d = (int2)(get_global_id(0), get_global_id(1));
  float4 col = read_imagef(in, format, d);
  write_imagef(out, d, col);
}