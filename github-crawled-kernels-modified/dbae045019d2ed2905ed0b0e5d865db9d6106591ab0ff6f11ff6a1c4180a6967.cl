//{"height":2,"idata":1,"odata":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_simple(global float* odata, global float* idata, int height, int width) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  if (i < height && j < width) {
    unsigned int in = i * width + j;
    unsigned int out = j * height + i;
    odata[hook(0, out)] = idata[hook(1, in)];
  }
}