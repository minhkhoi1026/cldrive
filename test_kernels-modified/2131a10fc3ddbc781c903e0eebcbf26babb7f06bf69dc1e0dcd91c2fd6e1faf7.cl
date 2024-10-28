//{"dx":4,"dy":5,"height":3,"integral_img":0,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 2 | 0x10);
kernel void horiz_sum(global uint4* integral_img, read_only image2d_t src, int width, int height, int4 dx, int4 dy) {
  int y = get_global_id(0);
  int work_size = get_global_size(0);

  uint4 sum = (uint4)(0);
  float4 s2;
  for (int i = 0; i < width; i++) {
    float s1 = read_imagef(src, sampler, (int2)(i, y)).x;
    s2.x = read_imagef(src, sampler, (int2)(i + dx.x, y + dy.x)).x;
    s2.y = read_imagef(src, sampler, (int2)(i + dx.y, y + dy.y)).x;
    s2.z = read_imagef(src, sampler, (int2)(i + dx.z, y + dy.z)).x;
    s2.w = read_imagef(src, sampler, (int2)(i + dx.w, y + dy.w)).x;
    sum += convert_uint4((s1 - s2) * (s1 - s2) * 255 * 255);
    integral_img[hook(0, y * width + i)] = sum;
  }
}