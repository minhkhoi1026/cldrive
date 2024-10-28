//{"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(global char* input, global char* output, int width, int height) {
  unsigned int i = get_global_id(0);

  unsigned int i_mul_4 = i * 4;

  unsigned int x, y;

  y = i / width;

  x = i % width;

  if ((x < width - 1) && (x > 0) && (y > 0) && (y < height - 1)) {
    unsigned int temp;
    temp = -input[hook(0, i_mul_4 - 4)] + 8 * input[hook(0, i_mul_4)] + -input[hook(0, i_mul_4 + 4)] +

           -input[hook(0, i_mul_4 - 4 - 4 * width)] + -input[hook(0, i_mul_4 - 4 + 4 * width)] +

           -input[hook(0, i_mul_4 + 4 - 4 * width)] + -input[hook(0, i_mul_4 + 4 + 4 * width)] +

           -input[hook(0, i_mul_4 - 4 * width)] + -input[hook(0, i_mul_4 + 4 * width)];

    temp = temp;
    if (temp > 255) {
      output[hook(1, i_mul_4)] = 255;
    } else {
      output[hook(1, i_mul_4)] = temp;
    }

    temp = -input[hook(0, i_mul_4 - 3)] + 8 * input[hook(0, i_mul_4 + 1)] + -input[hook(0, i_mul_4 + 5)] +

           -input[hook(0, i_mul_4 - 3 - 4 * width)] + -input[hook(0, i_mul_4 - 3 + 4 * width)] +

           -input[hook(0, i_mul_4 + 5 - 4 * width)] + -input[hook(0, i_mul_4 + 5 + 4 * width)] +

           -input[hook(0, i_mul_4 - 4 * width + 1)] + -input[hook(0, i_mul_4 + 4 * width + 1)];

    temp = temp;
    if (temp > 255) {
      output[hook(1, i_mul_4 + 1)] = 255;
    } else {
      output[hook(1, i_mul_4 + 1)] = temp;
    }

    temp = -input[hook(0, i_mul_4 - 2)] + 8 * input[hook(0, i_mul_4 + 2)] + -input[hook(0, i_mul_4 + 6)] +

           -input[hook(0, i_mul_4 - 2 - 4 * width)] + -input[hook(0, i_mul_4 - 2 + 4 * width)] +

           -input[hook(0, i_mul_4 + 6 - 4 * width)] + -input[hook(0, i_mul_4 + 6 + 4 * width)] +

           -input[hook(0, i_mul_4 - 4 * width + 2)] + -input[hook(0, i_mul_4 + 4 * width + 2)];

    temp = temp;
    if (temp > 255) {
      output[hook(1, i_mul_4 + 2)] = 255;
    } else {
      output[hook(1, i_mul_4 + 2)] = temp;
    }

  } else {
    output[hook(1, i_mul_4)] = input[hook(0, i_mul_4)];
    output[hook(1, i_mul_4 + 1)] = input[hook(0, i_mul_4 + 1)];
    output[hook(1, i_mul_4 + 2)] = input[hook(0, i_mul_4 + 2)];
  }

  output[hook(1, i_mul_4 + 3)] = input[hook(0, i_mul_4 + 3)];
}