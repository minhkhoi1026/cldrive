//{"UVPlane":1,"UVPlaneOut":3,"YPlane":0,"YPlaneOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_planar_seperate(read_only image2d_t YPlane, read_only image2d_t UVPlane, write_only image2d_t YPlaneOut, write_only image2d_t UVPlaneOut) {
  const sampler_t sampler = 0 | 0x10;
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  float4 colorY = read_imagef(YPlane, sampler, loc);
  float4 colorUV = read_imagef(UVPlane, sampler, loc / 2);
  colorY.x += 1 / 255.0f;
  colorUV += 1 / 255.0f;
  write_imagef(YPlaneOut, loc, colorY);
  write_imagef(UVPlaneOut, loc / 2, colorUV);
}