//{"dst":0,"fillColor":2,"h":6,"lineColor":1,"w":5,"x":3,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void drawRectangle(write_only image2d_t dst, float4 lineColor, float4 fillColor, unsigned int x, unsigned int y, unsigned int w, unsigned int h) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);

  if ((gid_x < x) || (gid_x > x + w) || (gid_y < y) || (gid_y > y + h)) {
    return;
  }
  write_imagef(dst, (int2)(gid_x, gid_y), fillColor);
}