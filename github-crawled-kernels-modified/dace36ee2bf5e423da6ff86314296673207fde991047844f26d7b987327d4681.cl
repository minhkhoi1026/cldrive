//{"dimx":3,"dimy":4,"grid_list_in":0,"grid_list_out":1,"m":5,"num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int is_valid_number_row(global const uchar* m, uchar num, int x, int y, int dim, int dim2) {
  for (int j = 0; j < dim; j++) {
    int index = x * dim2 + j * dim;
    if (j != y && m[hook(5, index)] == num && !m[hook(5, index + 1)])
      return 0;
  }

  return 1;
}

int is_valid_number_column(global const uchar* m, uchar num, int x, int y, int dim, int dim2) {
  for (int i = 0; i < dim; i++) {
    int index = i * dim2 + y * dim;
    if (i != x && m[hook(5, index)] == num && !m[hook(5, index + 1)])
      return 0;
  }

  return 1;
}

int is_valid_number_square(global const uchar* m, uchar num, int x, int y, int dimx, int dimy, int dim, int dim2) {
  int start_i = (x / dimx) * dimx;
  int start_j = (y / dimy) * dimy;

  for (int i = start_i; i < start_i + dimx; i++)
    for (int j = start_j; j < start_j + dimy; j++) {
      int index = i * dim2 + j * dim;
      if ((i != x || j != y) && m[hook(5, index)] == num && !m[hook(5, index + 1)])
        return 0;
    }

  return 1;
}

int is_valid_number(global const uchar* m, uchar num, int x, int y, int dimx, int dimy) {
  int dim = dimx * dimy;
  int dim2 = dim * dim;

  return is_valid_number_row(m, num, x, y, dim, dim2) && is_valid_number_column(m, num, x, y, dim, dim2) && is_valid_number_square(m, num, x, y, dimx, dimy, dim, dim2);
}

kernel void resolve(global const uchar* grid_list_in, global uchar* grid_list_out, int num, int dimx, int dimy) {
  int l = get_global_id(0);
  int x = get_group_id(1);
  int y = get_local_id(1);
  int dim = dimx * dimy;
  int dim2 = dim * dim;
  int dim3 = dim2 * dim;

  if (x >= dim || y >= dim || l >= num)
    return;

  int end = 0, z_out, z;
  int t = l * dim3;
  int i = t + x * dim2 + y * dim;

  if (grid_list_in[hook(0, i)]) {
    if (!grid_list_in[hook(0, i + 1)]) {
      grid_list_out[hook(1, i)] = grid_list_in[hook(0, i)];
      grid_list_out[hook(1, i + 1)] = 0;
    } else if (grid_list_in[hook(0, i + 1)] != 255) {
      for (z = 0, z_out = 0; z < dim && grid_list_in[hook(0, i + z)]; z++)
        if (is_valid_number(&grid_list_in[hook(0, t)], grid_list_in[hook(0, i + z)], x, y, dimx, dimy)) {
          grid_list_out[hook(1, i + z_out)] = grid_list_in[hook(0, i + z)];
          z_out++;
        }
      if (z_out == 1)
        grid_list_out[hook(1, i + 1)] = 255;
      else if (z_out < dim)
        grid_list_out[hook(1, i + z_out)] = 0;
    } else {
      if (is_valid_number(&grid_list_in[hook(0, t)], grid_list_in[hook(0, i)], x, y, dimx, dimy)) {
        grid_list_out[hook(1, i)] = grid_list_in[hook(0, i)];
        grid_list_out[hook(1, i + 1)] = 0;
      } else
        grid_list_out[hook(1, i)] = 0;
    }
  } else {
    for (z = 1, z_out = 0; z <= dim; z++)
      if (is_valid_number(&grid_list_in[hook(0, t)], z, x, y, dimx, dimy)) {
        grid_list_out[hook(1, i + z_out)] = z;
        z_out++;
      }
    if (z_out == 1)
      grid_list_out[hook(1, i + 1)] = 255;
    else if (z_out < dim)
      grid_list_out[hook(1, i + z_out)] = 0;
  }
}