//{"dst":0,"progress":3,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 0x10);
kernel void wiperight(write_only image2d_t dst, read_only image2d_t src1, read_only image2d_t src2, float progress) {
  int s = (int)(get_image_dim(src1).x * (1.f - progress));
  int2 p = (int2)(get_global_id(0), get_global_id(1));

  float4 val1 = read_imagef(src1, sampler, p);
  float4 val2 = read_imagef(src2, sampler, p);

  write_imagef(dst, p, p.x > s ? val1 : val2);
}