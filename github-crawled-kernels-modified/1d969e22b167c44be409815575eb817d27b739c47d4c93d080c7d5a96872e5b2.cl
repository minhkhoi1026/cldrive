//{"dest":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_memcpy_tex_RGBA(global float* dest, read_only image2d_t source) {
  const sampler_t smp = 0 | 2 | 0x10;
  int x = get_global_id(0);
  int rgbx = x >> 2;
  int2 coord;
  coord.x = rgbx & 1023;
  coord.y = rgbx >> 10;
  float4 ans = read_imagef(source, smp, coord);
  int rgbid = x % 4;
  int finalans = ans.x;
  if (rgbid == 1)
    finalans = ans.y;
  else if (rgbid == 2)
    finalans = ans.z;
  else if (rgbid == 3)
    finalans = ans.w;
  dest[hook(0, x)] = finalans;
}