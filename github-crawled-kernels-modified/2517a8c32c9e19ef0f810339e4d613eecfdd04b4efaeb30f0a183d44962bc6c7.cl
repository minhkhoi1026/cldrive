//{"pc3d":1,"pc8d":0,"rgb":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void splitPC8D_octomap(global float8* pc8d, global float* pc3d, global uchar* rgb) {
  unsigned int gX = get_global_id(0);

  float8 point = pc8d[hook(0, gX)];
  vstore3(point.s012 * 0.001f, gX, pc3d);
  vstore3(convert_uchar3(point.s456 * 255.f), gX, rgb);
}