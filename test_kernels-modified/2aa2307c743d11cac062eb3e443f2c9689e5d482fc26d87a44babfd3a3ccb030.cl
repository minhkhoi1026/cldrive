//{"height":3,"i_00":4,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(global unsigned char* input, global unsigned char* output, int width, int height) {
  unsigned int pos = get_global_id(0);

  unsigned int x, y;

  unsigned int i_mul_4 = pos * 4;

  x = pos / width;
  y = pos % width;

  unsigned char i_00[(7 * 7)];
  unsigned int summ, aver, disp, len, curr_disp, curr_aver;
  unsigned int c;

  unsigned int i_mul_4_new = ((y * width + x) * 4);

  if ((x <= (width - 7 - 1)) && (y <= (height - 7 - 1)) && (x >= 7) && (y >= 7)) {
    c = 0;
    for (int i = 0; i < 7; ++i) {
      for (int j = 0; j < 7; ++j) {
        i_00[hook(4, c)] = input[hook(0, (((y - i) * width + (x - j)) * 4))];
        c++;
      }
    }

    summ = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      summ += i_00[hook(4, i)];
    }
    aver = summ / (7 * 7);

    disp = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      len = i_00[hook(4, i)] - aver;
      disp += len * len;
    }
    disp = disp / (7 * 7);

    c = 0;
    for (int i = 0; i < 7; ++i) {
      for (int j = 0; j < 7; ++j) {
        i_00[hook(4, c)] = input[hook(0, (((y - i) * width + (x + j)) * 4))];
        c++;
      }
    }

    summ = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / (7 * 7);

    curr_disp = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / (7 * 7);

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    c = 0;
    for (int i = 0; i < 7; ++i) {
      for (int j = 0; j < 7; ++j) {
        i_00[hook(4, c)] = input[hook(0, (((y + i) * width + (x - j)) * 4))];
        c++;
      }
    }

    summ = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / (7 * 7);

    curr_disp = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / (7 * 7);

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    c = 0;
    for (int i = 0; i < 7; ++i) {
      for (int j = 0; j < 7; ++j) {
        i_00[hook(4, c)] = input[hook(0, (((y + i) * width + (x + j)) * 4))];
        c++;
      }
    }

    summ = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      summ += i_00[hook(4, i)];
    }
    curr_aver = summ / (7 * 7);

    curr_disp = 0;
    for (int i = 0; i < (7 * 7); ++i) {
      len = i_00[hook(4, i)] - curr_aver;
      curr_disp += len * len;
    }
    curr_disp = curr_disp / (7 * 7);

    if (curr_disp < disp) {
      disp = curr_disp;
      aver = curr_aver;
    }

    if (aver > 255) {
      output[hook(1, i_mul_4_new)] = 255;
      output[hook(1, i_mul_4_new + 1)] = 255;
      output[hook(1, i_mul_4_new + 2)] = 255;
    } else {
      output[hook(1, i_mul_4_new)] = aver;
      output[hook(1, i_mul_4_new + 1)] = aver;
      output[hook(1, i_mul_4_new + 2)] = aver;
    }

    output[hook(1, i_mul_4_new + 3)] = input[hook(0, i_mul_4 + 3)];
  } else {
    output[hook(1, i_mul_4_new)] = 0;
    output[hook(1, i_mul_4_new + 1)] = 0;
    output[hook(1, i_mul_4_new + 2)] = 0;
    output[hook(1, i_mul_4_new + 3)] = 0;
  }
}