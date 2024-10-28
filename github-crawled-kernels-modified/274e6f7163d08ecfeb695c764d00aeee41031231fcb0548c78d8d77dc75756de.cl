//{"buf":1,"input":0,"map":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler_warp = 1 | 2 | 0x20;
kernel void warp(read_only image2d_t input, global uchar* buf, global float* map) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  float fx = (float)gidx / (float)get_global_size(0);
  float fy = (float)gidy / (float)get_global_size(1);
  float3 frgb;
  float3 M1 = (float3)(map[hook(2, 0)], map[hook(2, 1)], map[hook(2, 2)]);
  float3 M2 = (float3)(map[hook(2, 3)], map[hook(2, 4)], map[hook(2, 5)]);
  float3 M3 = (float3)(map[hook(2, 6)], map[hook(2, 7)], map[hook(2, 8)]);

  float3 pos_src = (float3)(fx, fy, 1.0);
  float div_factor = dot(M3, pos_src);
  float2 pos_dst = (float2)(dot(M1, pos_src) / div_factor, dot(M2, pos_src) / div_factor);

  frgb = read_imagef(input, sampler_warp, pos_dst).s012;
  frgb *= 255.f;

  vstore3(convert_uchar3(frgb), 0, buf + ((gidy * get_global_size(0)) + gidx) * 3);
}