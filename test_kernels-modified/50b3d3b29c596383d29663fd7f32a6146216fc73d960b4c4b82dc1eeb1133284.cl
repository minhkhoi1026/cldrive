//{"bufin":0,"bufout":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void paint_ids(global uchar4* bufin, global uchar4* bufout, constant int* width) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_local_id(0);
  unsigned int k = get_group_id(0);

  unsigned int r, g, b;

  r = i % 256;

  g = j % 256;

  b = k % 256;

  bufout[hook(1, i)] = convert_uchar4_sat((uint4)(0, g, b, 255));

  bufout[hook(1, i)].w = bufin[hook(0, i)].w;
}