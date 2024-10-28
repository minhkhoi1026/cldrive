//{"dst":1,"sampler":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_movforphi_undef(read_only image2d_t src, write_only image2d_t dst, sampler_t sampler) {
  int2 coord, dstCoord;
  int4 float3;
  int x = get_global_id(0);
  int y = get_global_id(1);
  dstCoord.x = x;
  dstCoord.y = y;
  coord.y = y;
  for (int j = -8; j < 2; j++) {
    coord.x = j + x;
    float3 = read_imagei(src, sampler, coord);
    if (j == 1 + x)
      write_imagei(dst, dstCoord, float3);
  }
}