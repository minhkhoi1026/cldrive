//{"height":4,"idata":1,"odata":0,"offset":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_naive(global float* odata, global float* idata, int offset, int width, int height) {
  unsigned int xIndex = get_global_id(0);
  unsigned int yIndex = get_global_id(1);

  if (xIndex + offset < width && yIndex < height) {
    unsigned int index_in = xIndex + offset + width * yIndex;
    unsigned int index_out = yIndex + height * xIndex;
    odata[hook(0, index_out)] = idata[hook(1, index_in)];
  }
}