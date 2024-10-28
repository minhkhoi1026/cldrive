//{"height":2,"input":3,"output":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void embossment(global float* output, const unsigned int width, const unsigned int height, global float* input) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);
  unsigned int i = (iy * width + ix) * 4;

  if (i >= 0 && i < (width * height * 4 - 4)) {
    int row = iy;
    int col = ix;
    int A = ((row - 1) * width + (col - 1)) * 4;
    int G = (row + 1) * width * 4 + (col + 1) * 4;
    if (row == 0 || col == 0 || row + 1 >= height || col + 1 >= width)
      return;
    output[hook(0, i + 0)] = input[hook(3, A + 0)] - input[hook(3, G + 0)] + 127.5;
    output[hook(0, i + 1)] = input[hook(3, A + 1)] - input[hook(3, G + 1)] + 127.5;
    output[hook(0, i + 2)] = input[hook(3, A + 2)] - input[hook(3, G + 2)] + 127.5;
  }
}