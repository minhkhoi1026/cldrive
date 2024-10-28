//{"height":3,"i_00":4,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(global char* input, global char* output, int width, int height) {
  unsigned int i = get_global_id(0);

  unsigned int x, y;

  unsigned int i_mul_4 = i * 4;

  x = i / width;
  y = i % width;

  unsigned char i_00[9];
  unsigned int summ, aver, disp, len, curr_disp, curr_aver;

  unsigned int i_mul_4_new = ((y * width + x) * 4);

  if ((x <= (width - 4)) && (y <= (height - 4)) && (x >= 3) && (y >= 3)) {
    i_00[hook(4, 0)] = input[hook(0, (((y - 2) * width + (x - 2)) * 4))];
    i_00[hook(4, 1)] = input[hook(0, (((y - 2) * width + (x - 1)) * 4))];
    i_00[hook(4, 2)] = input[hook(0, (((y - 2) * width + (x)) * 4))];
    i_00[hook(4, 3)] = input[hook(0, (((y - 1) * width + (x - 2)) * 4))];
    i_00[hook(4, 4)] = input[hook(0, (((y - 1) * width + (x - 1)) * 4))];
    i_00[hook(4, 5)] = input[hook(0, (((y - 1) * width + (x)) * 4))];
    i_00[hook(4, 6)] = input[hook(0, (((y) * width + (x - 2)) * 4))];
    i_00[hook(4, 7)] = input[hook(0, (((y) * width + (x - 1)) * 4))];
    i_00[hook(4, 8)] = input[hook(0, (((y) * width + (x)) * 4))];

    summ = 0;
    for (int i = 0; i <= 8; ++i) {
      summ += i_00[hook(4, i)];
    }
    aver = summ / 9;

    disp = 0;
    for (int i = 0; i <= 8; ++i) {
      len = i_00[hook(4, i)] - aver;
      disp += len * len;
    }
    disp = disp / 9;

    i_00[hook(4, 0)] = input[hook(0, (((y - 2) * width + (x)) * 4))];
    i_00[hook(4, 1)] = input[hook(0, (((y - 2) * width + (x + 1)) * 4))];
    i_00[hook(4, 2)] = input[hook(0, (((y - 2) * width + (x + 2)) * 4))];
    i_00[hook(4, 3)] = input[hook(0, (((y - 1) * width + (x)) * 4))];
    i_00[hook(4, 4)] = input[hook(0, (((y - 1) * width + (x + 1)) * 4))];
    i_00[hook(4, 5)] = input[hook(0, (((y - 1) * width + (x + 2)) * 4))];
    i_00[hook(4, 6)] = input[hook(0, (((y) * width + (x)) * 4))];
    i_00[hook(4, 7)] = input[hook(0, (((y) * width + (x + 1)) * 4))];
    i_00[hook(4, 8)] = input[hook(0, (((y) * width + (x + 2)) * 4))];

    summ = 0;
    for (int i = 0; i <= 8; ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / 9;

    curr_disp = 0;
    for (int i = 0; i <= 8; ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / 9;

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    i_00[hook(4, 0)] = input[hook(0, (((y) * width + (x - 2)) * 4))];
    i_00[hook(4, 1)] = input[hook(0, (((y) * width + (x - 1)) * 4))];
    i_00[hook(4, 2)] = input[hook(0, (((y) * width + (x)) * 4))];
    i_00[hook(4, 3)] = input[hook(0, (((y + 1) * width + (x - 2)) * 4))];
    i_00[hook(4, 4)] = input[hook(0, (((y + 1) * width + (x - 1)) * 4))];
    i_00[hook(4, 5)] = input[hook(0, (((y + 1) * width + (x)) * 4))];
    i_00[hook(4, 6)] = input[hook(0, (((y + 2) * width + (x - 2)) * 4))];
    i_00[hook(4, 7)] = input[hook(0, (((y + 2) * width + (x - 1)) * 4))];
    i_00[hook(4, 8)] = input[hook(0, (((y + 2) * width + (x)) * 4))];

    summ = 0;
    for (int i = 0; i <= 8; ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / 9;

    curr_disp = 0;
    for (int i = 0; i <= 8; ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / 9;

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    i_00[hook(4, 0)] = input[hook(0, (((y) * width + (x)) * 4))];
    i_00[hook(4, 1)] = input[hook(0, (((y) * width + (x + 1)) * 4))];
    i_00[hook(4, 2)] = input[hook(0, (((y) * width + (x + 2)) * 4))];
    i_00[hook(4, 3)] = input[hook(0, (((y + 1) * width + (x)) * 4))];
    i_00[hook(4, 4)] = input[hook(0, (((y + 1) * width + (x + 1)) * 4))];
    i_00[hook(4, 5)] = input[hook(0, (((y + 1) * width + (x + 2)) * 4))];
    i_00[hook(4, 6)] = input[hook(0, (((y + 2) * width + (x)) * 4))];
    i_00[hook(4, 7)] = input[hook(0, (((y + 2) * width + (x + 1)) * 4))];
    i_00[hook(4, 8)] = input[hook(0, (((y + 2) * width + (x + 2)) * 4))];

    summ = 0;
    for (int i = 0; i <= 8; ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / 9;

    curr_disp = 0;
    for (int i = 0; i <= 8; ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / 9;

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    output[hook(1, i_mul_4_new)] = aver;
    output[hook(1, i_mul_4_new + 1)] = aver;
    output[hook(1, i_mul_4_new + 2)] = aver;

    output[hook(1, i_mul_4_new + 3)] = input[hook(0, i_mul_4 + 3)];
  } else {
    output[hook(1, i_mul_4_new)] = 0;
    output[hook(1, i_mul_4_new + 1)] = 0;
    output[hook(1, i_mul_4_new + 2)] = 0;
    output[hook(1, i_mul_4_new + 3)] = 0;
  }
}