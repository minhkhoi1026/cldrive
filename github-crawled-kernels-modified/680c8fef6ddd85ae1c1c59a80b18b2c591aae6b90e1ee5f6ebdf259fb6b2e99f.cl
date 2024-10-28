//{"datacost":2,"dispRange":5,"height":4,"left":0,"mSize":6,"right":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int index_y(int y, int height) {
  if (0 <= y && y < height)
    return y;
  else if (y < 0)
    return 0;
  else
    return height - 1;
}

int index_x(int x, int width) {
  if (0 <= x && x < width)
    return x;
  else if (x < 0)
    return 0;
  else
    return width - 1;
}

kernel void SAD_Disparity(global uchar* left, global uchar* right, global float* datacost, int width, int height, int dispRange, int mSize) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int tz = get_local_id(2);
  int j = tx + get_group_id(0) * get_local_size(0);
  int i = ty + get_group_id(1) * get_local_size(1);
  int k = tz + get_group_id(2) * get_local_size(2);

  int x, y;
  unsigned int diff = 0;
  unsigned int L, R;
  if (j - k >= 0) {
    diff = 0;
    for (int m = -mSize; m <= mSize; m++) {
      for (int n = -mSize; n <= mSize; n++) {
        y = i + m;
        y = index_y(y, height);

        x = j + n;
        x = index_x(x, width);
        L = left[hook(0, y * width + x)];

        x = j + n - k;
        x = index_x(x, width);
        R = right[hook(1, y * width + x)];

        diff += abs_diff(L, R);
      }
    }

    datacost[hook(2, dispRange * (width * i + j) + k)] = diff / 255.0f;
  } else {
    datacost[hook(2, dispRange * (width * i + j) + k)] = 1000.0f;
  }
}