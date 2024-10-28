//{"dst":0,"progress":3,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = (0 | 0x10);
void slide(write_only image2d_t dst, read_only image2d_t src1, read_only image2d_t src2, float progress, int2 direction) {
  int w = get_image_dim(src1).x;
  int h = get_image_dim(src1).y;
  int2 wh = (int2)(w, h);
  int2 uv = (int2)(get_global_id(0), get_global_id(1));
  int2 pi = (int2)(progress * w, progress * h);
  int2 p = uv + pi * direction;
  int2 f = p % wh;

  f = f + (int2)(w, h) * (int2)(f.x < 0, f.y < 0);
  float4 val1 = read_imagef(src1, sampler, f);
  float4 val2 = read_imagef(src2, sampler, f);
  write_imagef(dst, uv, mix(val1, val2, (p.y >= 0) * (h > p.y) * (p.x >= 0) * (w > p.x)));
}

kernel void slideup(write_only image2d_t dst, read_only image2d_t src1, read_only image2d_t src2, float progress) {
  int2 direction = (int2)(0, -1);
  slide(dst, src1, src2, progress, direction);
}