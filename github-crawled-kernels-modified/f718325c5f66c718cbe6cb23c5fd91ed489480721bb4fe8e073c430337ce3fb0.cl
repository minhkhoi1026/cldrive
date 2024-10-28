//{"in":1,"out":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int row0 = width * (y + 0);
  int row1 = width * (y + 1);
  int row2 = width * (y + 2);

  int intVal = (int)(

      +in[hook(1, row0 + x + 0)] + in[hook(1, row0 + x + 1)] + in[hook(1, row0 + x + 2)]

      + in[hook(1, row1 + x + 0)] + in[hook(1, row1 + x + 1)] + in[hook(1, row1 + x + 2)]

      + in[hook(1, row2 + x + 0)] + in[hook(1, row2 + x + 1)] + in[hook(1, row2 + x + 2)]);

  intVal /= 9;
  out[hook(2, row1 + x + 1)] = convert_uchar_sat(intVal);
}