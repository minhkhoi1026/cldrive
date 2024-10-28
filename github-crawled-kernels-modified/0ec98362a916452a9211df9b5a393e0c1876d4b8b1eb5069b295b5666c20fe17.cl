//{"dest":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_memcpy_tex_RGBA4(global float4* dest, read_only image2d_t source) {
  const sampler_t smp = 0 | 2 | 0x10;
  int x = get_global_id(0);
  int2 coord;
  coord.x = x & 1023;
  coord.y = x >> 10;
  float4 ans = read_imagef(source, smp, coord);
  dest[hook(0, x)] = ans;
}