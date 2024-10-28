//{"dst":2,"factor":4,"kernelSize":0,"options":3,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
int2 borderCoord(int2 coord, const int2 maxCoord) {
  coord = convert_int2(abs(coord));
  const int2 minValue = maxCoord * (int2)(2, 2) - coord;
  return minValue + (coord - minValue) * max(min(maxCoord - coord, (int2)(1, 1)), (int2)(0, 0));
}

kernel void krn_filterGauss(const int2 kernelSize, read_only image2d_t src, write_only image2d_t dst, const int8 options, const float4 factor) {
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  if (any(coord >= kernelSize))
    return;
  const int2 srcCoord = coord * options.s23;
  const float4 float3 =

      read_imagef(src, sampler, borderCoord(srcCoord, options.s01)) * (float4)(0.375f)

      + read_imagef(src, sampler, borderCoord(srcCoord + (int2)(1, 1) * options.s67, options.s01)) * (float4)(0.25f) + read_imagef(src, sampler, borderCoord(srcCoord - (int2)(1, 1) * options.s67, options.s01)) * (float4)(0.25f)

      + read_imagef(src, sampler, borderCoord(srcCoord + (int2)(2, 2) * options.s67, options.s01)) * (float4)(0.0625f) + read_imagef(src, sampler, borderCoord(srcCoord - (int2)(2, 2) * options.s67, options.s01)) * (float4)(0.0625f);
  write_imagef(dst, coord * options.s45, float3 * factor);
}