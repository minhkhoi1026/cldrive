//{"alphas":2,"cols":3,"dst":1,"flip":10,"rows":4,"src":0,"start_col":12,"stop_col":13,"that_steps":15,"this_steps":14,"transpose":11,"viewHeight":7,"x":5,"xres":8,"y":6,"yres":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int xy_to_fancy_index(int cols, int x, int y) {
  int tile_row_words = cols * (1 << (5));
  int tile_x = x >> (5);
  int tile_y = y >> (5);
  int major_index = (tile_y * tile_row_words) + (tile_x * (1 << (5)) * (1 << (5)));

  int subtile_row_words = (1 << (5)) * (1 << (2));
  int subtile_x = (x & (0x1f)) >> (2);
  int subtile_y = (y & (0x1f)) >> (2);
  int minor_index = (subtile_y * subtile_row_words) + (subtile_x * (1 << (2)) * (1 << (2)));

  int micro_row_words = (1 << (2));
  int micro_x = x & (0x03);
  int micro_y = y & (0x03);
  int micro_index = (micro_y * micro_row_words) + micro_x;

  return major_index + minor_index + micro_index;
}

int xy_to_vanilla_index(int cols, int x, int y) {
  return (y * cols) + x;
}

kernel void viewshed(global float* src, global float* dst, global float* alphas, int cols, int rows, int x, int y, float viewHeight, float xres, float yres, int flip, int transpose, int start_col, int stop_col, int this_steps, int that_steps) {
  int gid = get_global_id(0);
  int row = gid * this_steps;

  if (!(row < rows) && (row - this_steps < rows))
    row = rows - 1;

  if (row < rows) {
    float dy = ((float)(row - y)) / (cols - x);
    float dm = sqrt(xres * xres + dy * dy * yres * yres);
    float current_y = y + ((start_col - x) * dy);
    float current_distance = (1 / 0x1.fffffep127f) + ((start_col - x) * dm);
    float alpha;

    if (start_col == x)
      alpha = -(__builtin_inff());
    else
      alpha = alphas[hook(2, row)];

    for (int col = start_col; col < stop_col; ++col, current_y += dy, current_distance += dm) {
      int index;
      if (!flip && !transpose)
        index = xy_to_fancy_index(cols, col, convert_int(current_y));
      else if (flip && !transpose)
        index = xy_to_fancy_index(cols, (cols - 1 - col), convert_int(current_y));
      else if (!flip && transpose)
        index = xy_to_fancy_index(rows, convert_int(current_y), col);
      else if (flip && transpose)
        index = xy_to_fancy_index(rows, convert_int(current_y), (cols - 1 - col));
      float curve = 6378137 * (1 - cos(current_distance / 6378137));
      float elevation = src[hook(0, index)] - viewHeight - curve;
      float angle = elevation / current_distance;

      if (alpha < angle) {
        if (!flip && !transpose)
          index = xy_to_vanilla_index(cols, col, convert_int(current_y));
        else if (flip && !transpose)
          index = xy_to_vanilla_index(cols, (cols - col - 1), convert_int(current_y));
        else if (!flip && transpose)
          index = xy_to_vanilla_index(rows, convert_int(current_y), col);
        else if (flip && transpose)
          index = xy_to_vanilla_index(rows, convert_int(current_y), (cols - col - 1));
        alpha = angle;
        dst[hook(1, index)] = 1.0;
      }
    }

    for (int i = row; (i < row + this_steps) && (i < rows); ++i)
      alphas[hook(2, i)] = alpha;
  }
}