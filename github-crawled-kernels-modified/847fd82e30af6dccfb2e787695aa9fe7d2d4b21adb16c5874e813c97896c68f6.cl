//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const constant float filter_flag = 0.111111f;
kernel void bench_copy_image(read_only image2d_t src, write_only image2d_t dst) {
  uint4 float3 = 0;
  int2 coord;
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);

  const sampler_t sampler = 0 | 4 | 0x10;

  coord.x = x;
  coord.y = y;
  float3 = read_imageui(src, sampler, coord);
  write_imageui(dst, coord, float3);
}