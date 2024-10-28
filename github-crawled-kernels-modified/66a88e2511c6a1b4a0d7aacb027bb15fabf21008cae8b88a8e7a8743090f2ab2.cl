//{"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(global char* input, global char* output, int width, int height) {
  unsigned int i = get_global_id(0);

  unsigned int x, y;

  unsigned int i_mul_4 = i * 4;

  y = i / width;
  x = i % width;

  unsigned int x2, y2;

  x2 = y;
  y2 = x;

  if ((x2 < width) && (y2 < height)) {
    unsigned int i_mul_4_new = ((y2 * width + x2) * 4);

    output[hook(1, i_mul_4_new)] = input[hook(0, i_mul_4)];
    output[hook(1, i_mul_4_new + 1)] = input[hook(0, i_mul_4 + 1)];
    output[hook(1, i_mul_4_new + 2)] = input[hook(0, i_mul_4 + 2)];

    output[hook(1, i_mul_4_new + 3)] = input[hook(0, i_mul_4 + 3)];
  }
}