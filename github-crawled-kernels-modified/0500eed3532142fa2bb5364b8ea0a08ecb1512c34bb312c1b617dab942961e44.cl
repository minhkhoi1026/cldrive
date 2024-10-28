//{"a":0,"b":1,"c":2,"h":4,"w":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 pixel_over(float4 a, float4 b);
float4 pixel_blend(float4 a, float4 b);
float4 pixel_blend(float4 a, float4 b) {
  return a.w * a + (1 - a.w) * b;
}

float4 pixel_over(float4 a, float4 b) {
  return a.w * a + (1 - a.w) * b.w * b;
}

kernel void pixmap_over(read_write image2d_t a, read_write image2d_t b, read_write image2d_t c, unsigned int w, unsigned int h) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if ((x < (int)w) && (y < (int)h)) {
    int2 coord = {x, y};
    float4 ap = read_imagef(a, coord);
    float4 bp = read_imagef(b, coord);
    float4 cp = pixel_over(ap, bp);
    write_imagef(c, coord, cp);
  }
}