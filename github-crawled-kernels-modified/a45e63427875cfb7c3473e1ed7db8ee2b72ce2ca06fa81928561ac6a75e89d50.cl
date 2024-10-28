//{"ConvKernel":1,"X":2,"Y":3,"Z":4,"in":0,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Convolution_32f(global float* in, global float* ConvKernel, int X, int Y, int Z, global float* out) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int zhalfwidth = (Z - 1) / 2;
  int yhalfwidth = (Y - 1) / 2;
  int xhalfwidth = (X - 1) / 2;

  int temp_linear_coord, temp_kernel_coord;
  int linear_coords = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int MaxCoords = get_global_size(2) * get_global_size(1) * get_global_size(0);

  float final = 0;

  int zstart = -zhalfwidth;
  int zstop = zhalfwidth;
  int ystart = -yhalfwidth;
  int ystop = yhalfwidth;
  int xstart = -xhalfwidth;
  int xstop = xhalfwidth;

  if (zhalfwidth == 0 || Z > get_global_size(0)) {
    zstart = 0;
    zstop = 1;
  }

  if (yhalfwidth == 0 || Y > get_global_size(1)) {
    ystart = 0;
    ystop = 1;
  }

  if (xhalfwidth == 0 || X > get_global_size(2)) {
    xstart = 0;
    xstop = 1;
  }

  int tempx = 0;
  int tempy = 0;
  int tempz = 0;

  for (int z = zstart; z < zstop; z++) {
    for (int y = ystart; y < ystop; y++) {
      for (int x = xstart; x < xstop; x++) {
        if (i + x < 0 || i + x >= get_global_size(2)) {
          tempx = i;
        } else {
          tempx = i + x;
        }

        if (j + y < 0 || j + y >= get_global_size(1)) {
          tempy = j;
        } else {
          tempy = j + y;
        }

        if (k + z < 0 || k + z >= get_global_size(0)) {
          tempz = k;
        } else {
          tempz = k + z;
        }

        temp_linear_coord = (tempx) + (tempy)*get_global_size(2) + (tempz)*get_global_size(2) * get_global_size(1);
        temp_kernel_coord = (x + xhalfwidth) + X * (y + yhalfwidth) + X * Y * (z + zhalfwidth);
        final = mad(in[hook(0, temp_linear_coord)], ConvKernel[hook(1, temp_kernel_coord)], final);
      }
    }
  }

  out[hook(5, linear_coords)] = final;
}