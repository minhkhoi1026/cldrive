//{"cols":3,"comp_exit":6,"dst":2,"rem_rows":4,"shift_reg":7,"src":1,"starting_row":5,"wall":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void dynproc_kernel(global int* restrict wall, global int* restrict src, global int* restrict dst, int cols, int rem_rows, int starting_row, int comp_exit) {
  int shift_reg[256 + 1 + 16];

  for (int i = 0; i < 256 + 1 + 16; i++) {
    shift_reg[hook(7, i)] = 0.0f;
  }

  int x = 0;
  int y = 0;
  int bx = 0;
  int index = 0;

  while (index != comp_exit) {
    index++;

    for (int i = 0; i < 256 + 1; i++) {
      shift_reg[hook(7, i)] = shift_reg[hook(7, i + 16)];
    }

    for (int i = 0; i < 16; i++) {
      int gx = bx + x - rem_rows;
      int real_x = gx + i;
      int real_y = y + starting_row;
      int read_offset = real_x + (real_y - 1) * cols;
      int real_block_x = x + i - rem_rows;

      int north = 0x7ffffff, north_east = 0x7ffffff, north_west = 0x7ffffff, center = 0x7ffffff;
      int min = 0;

      int in = (y == 0 && real_x >= 0 && real_x < cols) ? src[hook(1, real_x)] : 0;

      if (real_block_x >= y - rem_rows && real_block_x < 256 - 2 * y && real_x >= 0 && real_x < cols) {
        center = (y == 0) ? in : wall[hook(0, read_offset)];
      }

      if (y > 0) {
        north = shift_reg[hook(7, 1 + i)];
        if (real_x > 0) {
          north_west = shift_reg[hook(7, 0 + i)];
        }
        if (real_x < cols - 1) {
          north_east = shift_reg[hook(7, 2 + i)];
        }
        min = ((north) <= (((north_east) <= (north_west) ? (north_east) : (north_west))) ? (north) : (((north_east) <= (north_west) ? (north_east) : (north_west))));
      }

      if (real_y >= 0 && real_block_x >= y - rem_rows && real_block_x < 256 - 2 * y && real_x >= 0 && real_x < cols) {
        shift_reg[hook(7, 256 + 1 + i)] = center + min;
        if (y == rem_rows) {
          dst[hook(2, real_x)] = shift_reg[hook(7, 256 + 1 + i)];
        }
      }
    }

    x = (x + 16) & (256 - 1);

    if (x == 0) {
      y++;

      if (y == rem_rows + 1) {
        y = 0;
        bx += 256 - 2 * rem_rows;
      }
    }
  }
}