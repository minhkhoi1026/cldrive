//{"in":1,"out":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int row0 = (y + 0) * width;
  int row1 = (y + 1) * width;
  int row2 = (y + 2) * width;

  int data = (int)(

      -in[hook(1, row0 + x + 1)]

      + in[hook(1, row1 + x + 0)] - in[hook(1, row1 + x + 2)]

      + in[hook(1, row2 + x + 1)]);

  data += 128;
  out[hook(2, row1 + x + 1)] = convert_uchar_sat(data);
}