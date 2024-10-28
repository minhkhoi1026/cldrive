//{"height":1,"in":2,"out":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, const unsigned int height, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int rowPitch = width * 3;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  unsigned int yUpper = y * rowPitch;
  unsigned int yLower = (height - y - 1) * rowPitch;

  out[hook(3, yUpper + x)] = in[hook(2, yLower + x)];
}