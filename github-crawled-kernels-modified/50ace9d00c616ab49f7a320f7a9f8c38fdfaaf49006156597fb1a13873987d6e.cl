//{"blockSize":3,"grid":0,"iterations":4,"temp":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diffuse(global float* grid, local float* temp, int width, int blockSize, int iterations) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int gx = get_global_id(0);
  int gy = get_global_id(1);

  temp[hook(1, ((tx) * (blockSize) + (ty)))] = grid[hook(0, ((gx) * (width) + (gy)))];
  barrier(0x01);

  int i;
  float left, right, up, down, value;
  for (i = 0; i < iterations; i++) {
    if (gx > 0 && gx < width - 1 && gy > 0 && gy < width - 1) {
      if (blockSize > 1) {
        if (tx == 0) {
          left = grid[hook(0, ((gx - 1) * (width) + (gy)))];
          right = temp[hook(1, ((tx + 1) * (blockSize) + (ty)))];
        } else if (tx == blockSize - 1) {
          right = grid[hook(0, ((gx + 1) * (width) + (gy)))];
          left = temp[hook(1, ((tx - 1) * (blockSize) + (ty)))];
        } else {
          left = temp[hook(1, ((tx - 1) * (blockSize) + (ty)))];
          right = temp[hook(1, ((tx + 1) * (blockSize) + (ty)))];
        }

        if (ty == 0) {
          up = grid[hook(0, ((gx) * (width) + (gy - 1)))];
          down = temp[hook(1, ((tx) * (blockSize) + (ty + 1)))];
        } else if (ty == blockSize - 1) {
          down = grid[hook(0, ((gx) * (width) + (gy + 1)))];
          up = temp[hook(1, ((tx) * (blockSize) + (ty - 1)))];
        } else {
          down = temp[hook(1, ((tx) * (blockSize) + (ty + 1)))];
          up = temp[hook(1, ((tx) * (blockSize) + (ty - 1)))];
        }

      } else {
        left = grid[hook(0, ((gx - 1) * (width) + (gy)))];
        right = grid[hook(0, ((gx + 1) * (width) + (gy)))];
        up = grid[hook(0, ((gx) * (width) + (gy - 1)))];
        down = grid[hook(0, ((gx) * (width) + (gy + 1)))];
      }
      value = (left + right + up + down) * 0.25;
      temp[hook(1, ((tx) * (blockSize) + (ty)))] = value;
      grid[hook(0, ((gx) * (width) + (gy)))] = value;
    }
    barrier(0x02);
  }
}