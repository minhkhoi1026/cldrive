//{"dividend":1,"divisor":2,"kernelSize":0,"quotient":3}
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

kernel void krn_div(const int2 kernelSize, read_only image2d_t dividend, read_only image2d_t divisor, write_only image2d_t quotient) {
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  if (any(coord >= kernelSize))
    return;
  write_imagef(quotient, coord, clamp(native_divide(read_imagef(dividend, sampler, coord), read_imagef(divisor, sampler, coord)), (float4)(0.0f, 0.0f, 0.0f, 0.0f), (float4)(1.0f, 1.0f, 1.0f, 1.0f)));
}