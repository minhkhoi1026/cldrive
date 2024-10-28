//{"in":2,"out":3,"pixelPitch":1,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int width, const int pixelPitch, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int lineOffset = rowPitch * y;
  int dstX = lineOffset + (x * pixelPitch);
  int srcX = lineOffset + ((width - 1) * pixelPitch - (x * pixelPitch));

  out[hook(3, dstX + 0)] = in[hook(2, srcX + 0)];
  out[hook(3, dstX + 1)] = in[hook(2, srcX + 1)];
  out[hook(3, dstX + 2)] = in[hook(2, srcX + 2)];
}