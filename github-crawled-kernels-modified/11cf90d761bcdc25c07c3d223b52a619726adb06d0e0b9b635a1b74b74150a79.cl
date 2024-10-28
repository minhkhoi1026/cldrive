//{"bias":3,"div":2,"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel_global(write_only image2d_t dst, read_only image2d_t src, float div, float bias) {
  const sampler_t sampler = (0 | 2 | 0x10);

  int2 loc = (int2)(get_global_id(0), get_global_id(1));

  float4 sum1 = read_imagef(src, sampler, loc + (int2)(-1, -1)) * -1 + read_imagef(src, sampler, loc + (int2)(0, -1)) * -2 + read_imagef(src, sampler, loc + (int2)(1, -1)) * -1 + read_imagef(src, sampler, loc + (int2)(-1, 1)) * 1 + read_imagef(src, sampler, loc + (int2)(0, 1)) * 2 + read_imagef(src, sampler, loc + (int2)(1, 1)) * 1;

  float4 sum2 = read_imagef(src, sampler, loc + (int2)(-1, -1)) * -1 + read_imagef(src, sampler, loc + (int2)(-1, 0)) * -2 + read_imagef(src, sampler, loc + (int2)(-1, 1)) * -1 + read_imagef(src, sampler, loc + (int2)(1, -1)) * 1 + read_imagef(src, sampler, loc + (int2)(1, 0)) * 2 + read_imagef(src, sampler, loc + (int2)(1, 1)) * 1;

  float4 dstPix = hypot(sum1, sum2) * div + bias;
  write_imagef(dst, loc, dstPix);
}