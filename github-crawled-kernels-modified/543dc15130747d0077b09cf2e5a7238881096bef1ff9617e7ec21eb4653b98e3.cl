//{"height":1,"in":2,"out":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil(int width, int height, global uchar* in, global uchar* out) {
  for (int x = 0; x < width / 4; x++) {
    for (int y = 1; y < height - 1; y++) {
      uchar4 right = (uchar4)(0);
      uchar16 center = vload16(((y)*width / 4 + (x)), in);

      uchar16 r = (uchar16)(center.s456789AB, center.sCDEF, right);

      vstore16(r, ((y)*width / 4 + (x)), out);
    }
  }
}