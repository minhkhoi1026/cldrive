//{"bufin":0,"bufout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void first(global uchar4* bufin, global uchar4* bufout) {
  int i = get_global_id(0);

  uchar4 c = bufin[hook(0, i)];
  uchar4 d;

  d.x = 255 - c.x;
  d.y = 255 - c.y;
  d.z = 255 - c.z;
  d.w = c.w;

  bufout[hook(1, i)] = d;
}