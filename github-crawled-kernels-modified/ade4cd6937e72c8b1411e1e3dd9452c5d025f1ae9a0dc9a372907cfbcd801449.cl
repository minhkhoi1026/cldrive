//{"big":2,"bigMaxCoord":3,"kernelSize":0,"small":1}
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

kernel void krn_upsample(const int2 kernelSize, read_only image2d_t small, write_only image2d_t big, const int2 bigMaxCoord) {
  const int2 smallCoord = (int2)(get_global_id(0), get_global_id(1));
  if (any(smallCoord >= kernelSize))
    return;
  const int2 bigCoord = smallCoord * (int2)(2, 2);
  write_imagef(big, min(bigCoord + (int2)(1, 0), bigMaxCoord), (float4)(0.0f));
  write_imagef(big, min(bigCoord + (int2)(0, 1), bigMaxCoord), (float4)(0.0f));
  write_imagef(big, min(bigCoord + (int2)(1, 1), bigMaxCoord), (float4)(0.0f));
  write_imagef(big, bigCoord, read_imagef(small, sampler, smallCoord));
}