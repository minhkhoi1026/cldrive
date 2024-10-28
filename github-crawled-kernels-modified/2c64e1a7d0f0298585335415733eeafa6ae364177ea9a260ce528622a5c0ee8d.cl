//{"dst":3,"kernelSize":0,"src1":1,"src2":2}
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

kernel void krn_sub(const int2 kernelSize, read_only image2d_t src1, read_only image2d_t src2, write_only image2d_t dst) {
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  if (any(coord >= kernelSize))
    return;
  write_imagef(dst, coord, read_imagef(src1, sampler, coord) - read_imagef(src2, sampler, coord));
}