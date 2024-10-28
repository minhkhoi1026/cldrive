//{"dst":1,"num":0,"sampler":3,"src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reverse4(int num, write_only image2d_t dst, read_only image2d_t src, sampler_t sampler) {
  size_t x = get_global_id(0);

  if (x >= num)
    return;

  float4 tap = read_imagef(src, sampler, (int2)(x, 0));

  write_imagef(dst, (int2)(num - x - 1, 0), tap.wzyx);
}