//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samin = 2 | 0x10;
kernel void filter(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  int w = get_image_width(src);
  int h = get_image_height(src);

  float4 a = read_imagef(src, samin, coords);
  float4 b = read_imagef(src, samin, coords + (int2)(1, 1));

  float la = length(a.xyz) / 3, lb = length(b.xyz) / 3;
  float d = fabs(la - lb);
  if (d < 0.1) {
    d = 0;
  } else {
    d = 1;
  }

  a = (float4)(d, d, d, 1);
  write_imagef(dst, coords, a);
}