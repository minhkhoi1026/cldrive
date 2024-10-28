//{"dst":1,"src":0,"thresh":2,"top":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClThreshold(read_only image2d_t src, write_only image2d_t dst, float thresh, float top) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 4 | 0x10;
  float4 p = read_imagef(src, smp, coords);

  if (p.x > thresh)
    p.x = top;
  else
    p.x = 0.0f;

  if (p.y > thresh)
    p.y = top;
  else
    p.y = 0.0f;

  if (p.z > thresh)
    p.z = top;
  else
    p.z = 0.0f;

  write_imagef(dst, coords, p);
}