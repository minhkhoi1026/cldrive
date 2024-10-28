//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClSwapRgb(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 4 | 0x10;
  float4 p = read_imagef(src, smp, coords);
  float f;

  f = p.x;
  p.x = p.z;
  p.z = f;

  write_imagef(dst, coords, p);
}