//{"dst":0,"fillColor":2,"h":6,"lineColor":1,"w":5,"x":3,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void drawEllipse(write_only image2d_t dst, float4 lineColor, float4 fillColor, unsigned int x, unsigned int y, unsigned int w, unsigned int h) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);

  float cx = (float)(gid_x) - (float)(x);
  float cy = (float)(gid_y) - (float)(y);
  float eval = (cx * cx) + (cy * cy);
  float r_sqr = w * w * 0.25f;
  float r2_sqr = (w - 10) * (w - 10) * 0.25f;

  if (eval < r_sqr && eval > r2_sqr) {
    write_imagef(dst, (int2)(gid_x, gid_y), lineColor);
  } else if (eval <= r2_sqr) {
    write_imagef(dst, (int2)(gid_x, gid_y), fillColor);
  }
}