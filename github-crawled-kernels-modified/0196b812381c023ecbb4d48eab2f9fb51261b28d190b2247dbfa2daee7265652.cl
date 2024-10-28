//{"cols":2,"l_data":4,"out":3,"rows":1,"theta":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nonMaxSupp(global unsigned char* theta, int rows, int cols, global unsigned char* out) {
  int g_row = get_global_id(0);
  int g_col = get_global_id(1);
  int l_row = get_local_id(0) + 1;
  int l_col = get_local_id(1) + 1;

  int offset = cols * rows;
  int pos = g_row * cols + g_col;

  local int l_data[(16 + 2) * (16 + 2)];

  l_data[hook(4, l_row * 18 + l_col)] = theta[hook(0, offset + pos)];

  if (l_row == 1) {
    l_data[hook(4, 0 * 18 + l_col)] = theta[hook(0, offset + pos - cols)];

    if (l_col == 1)
      l_data[hook(4, 0 * 18 + 0)] = theta[hook(0, offset + pos - cols - 1)];

    else if (l_col == 16)
      l_data[hook(4, 0 * 18 + 17)] = theta[hook(0, offset + pos - cols + 1)];
  }

  else if (l_row == 16) {
    l_data[hook(4, 17 * 18 + l_col)] = theta[hook(0, offset + pos + cols)];

    if (l_col == 1)
      l_data[hook(4, 17 * 18 + 0)] = theta[hook(0, offset + pos + cols - 1)];

    else if (l_col == 16)
      l_data[hook(4, 17 * 18 + 17)] = theta[hook(0, offset + pos + cols + 1)];
  }

  if (l_col == 1)
    l_data[hook(4, l_row * 18 + 0)] = theta[hook(0, offset + pos - 1)];
  else if (l_col == 16)
    l_data[hook(4, l_row * 18 + 17)] = theta[hook(0, offset + pos + 1)];

  barrier(0x01);

  unsigned char my_magnitude = l_data[hook(4, l_row * 18 + l_col)];

  switch (theta[hook(0, pos)]) {
    case 0:

      if (my_magnitude <= l_data[hook(4, l_row * 18 + l_col + 1)] || my_magnitude <= l_data[hook(4, l_row * 18 + l_col - 1)]) {
        out[hook(3, pos)] = 0;
      }

      else {
        out[hook(3, pos)] = my_magnitude;
      }
      break;

    case 45:

      if (my_magnitude <= l_data[hook(4, (l_row - 1) * 18 + l_col + 1)] || my_magnitude <= l_data[hook(4, (l_row + 1) * 18 + l_col - 1)]) {
        out[hook(3, pos)] = 0;
      }

      else {
        out[hook(3, pos)] = my_magnitude;
      }
      break;

    case 90:

      if (my_magnitude <= l_data[hook(4, (l_row - 1) * 18 + l_col)] || my_magnitude <= l_data[hook(4, (l_row + 1) * 18 + l_col)]) {
        out[hook(3, pos)] = 0;
      }

      else {
        out[hook(3, pos)] = my_magnitude;
      }
      break;

    case 135:

      if (my_magnitude <= l_data[hook(4, (l_row - 1) * 18 + l_col - 1)] || my_magnitude <= l_data[hook(4, (l_row + 1) * 18 + l_col + 1)]) {
        out[hook(3, pos)] = 0;
      }

      else {
        out[hook(3, pos)] = my_magnitude;
      }
      break;

    default:
      out[hook(3, pos)] = my_magnitude;
      break;
  }
}