//{"height":3,"idata":1,"odata":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mt(global float* odata, global const float* idata, int width, int height) {
  unsigned int row = get_global_id(1);
  unsigned int column = get_global_id(0);

  unsigned int indexIn = row * width + column;
  unsigned int indexOut = column * height + row;
  odata[hook(0, indexOut)] = idata[hook(1, indexIn)];
}