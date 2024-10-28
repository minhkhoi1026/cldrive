//{"bufin":0,"bufout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void second(global uchar4* bufin, global uchar4* bufout) {
  int i = get_global_id(0);

  uchar4 c = bufin[hook(0, i)];
  uchar4 d;

  uchar v;

  v = max(c.x, max(c.y, c.z));

  d.x = v;
  d.y = v;
  d.z = v;
  d.w = c.w;

  bufout[hook(1, i)] = d;
}