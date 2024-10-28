//{"_img":2,"cols":6,"counter":7,"d":10,"img":9,"img_offset":4,"kp_in":0,"kp_out":1,"max_keypoints":8,"rows":5,"step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int cornerScore(global const uchar* img, int step) {
  int k, tofs, v = img[hook(9, 0)], a0 = 0, b0;
  int d[16];

  tofs = 3;
  d[hook(10, 0)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 0 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step + 3;
  d[hook(10, 1)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 1 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step * 2 + 2;
  d[hook(10, 2)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 2 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step * 3 + 1;
  d[hook(10, 3)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 3 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step * 3;
  d[hook(10, 4)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 4 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step * 3 - 1;
  d[hook(10, 5)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 5 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step * 2 - 2;
  d[hook(10, 6)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 6 + 8)] = (short)(v - img[hook(9, -tofs)]);
  tofs = -step - 3;
  d[hook(10, 7)] = (short)(v - img[hook(9, tofs)]);
  d[hook(10, 7 + 8)] = (short)(v - img[hook(9, -tofs)]);

  for (k = 0; k < 16; k += 2) {
    int a = min((int)d[hook(10, (k + 1) & 15)], (int)d[hook(10, (k + 2) & 15)]);
    a = min(a, (int)d[hook(10, (k + 3) & 15)]);
    a = min(a, (int)d[hook(10, (k + 4) & 15)]);
    a = min(a, (int)d[hook(10, (k + 5) & 15)]);
    a = min(a, (int)d[hook(10, (k + 6) & 15)]);
    a = min(a, (int)d[hook(10, (k + 7) & 15)]);
    a = min(a, (int)d[hook(10, (k + 8) & 15)]);
    a0 = max(a0, min(a, (int)d[hook(10, k & 15)]));
    a0 = max(a0, min(a, (int)d[hook(10, (k + 9) & 15)]));
  }

  b0 = -a0;
  for (k = 0; k < 16; k += 2) {
    int b = max((int)d[hook(10, (k + 1) & 15)], (int)d[hook(10, (k + 2) & 15)]);
    b = max(b, (int)d[hook(10, (k + 3) & 15)]);
    b = max(b, (int)d[hook(10, (k + 4) & 15)]);
    b = max(b, (int)d[hook(10, (k + 5) & 15)]);
    b = max(b, (int)d[hook(10, (k + 6) & 15)]);
    b = max(b, (int)d[hook(10, (k + 7) & 15)]);
    b = max(b, (int)d[hook(10, (k + 8) & 15)]);

    b0 = min(b0, max(b, (int)d[hook(10, k)]));
    b0 = min(b0, max(b, (int)d[hook(10, (k + 9) & 15)]));
  }

  return -b0 - 1;
}

kernel void FAST_nonmaxSupression(global const int* kp_in, volatile global int* kp_out, global const uchar* _img, int step, int img_offset, int rows, int cols, int counter, int max_keypoints) {
  const int idx = get_global_id(0);

  if (idx < counter) {
    int x = kp_in[hook(0, 1 + 2 * idx)];
    int y = kp_in[hook(0, 2 + 2 * idx)];
    global const uchar* img = _img + mad24(y, step, x + img_offset);

    int s = cornerScore(img, step);

    if ((x < 4 || s > cornerScore(img - 1, step)) + (y < 4 || s > cornerScore(img - step, step)) != 2)
      return;
    if ((x >= cols - 4 || s > cornerScore(img + 1, step)) + (y >= rows - 4 || s > cornerScore(img + step, step)) + (x < 4 || y < 4 || s > cornerScore(img - step - 1, step)) + (x >= cols - 4 || y < 4 || s > cornerScore(img - step + 1, step)) + (x < 4 || y >= rows - 4 || s > cornerScore(img + step - 1, step)) + (x >= cols - 4 || y >= rows - 4 || s > cornerScore(img + step + 1, step)) == 6) {
      int new_idx = atomic_inc(kp_out);
      if (new_idx < max_keypoints) {
        kp_out[hook(1, 1 + 3 * new_idx)] = x;
        kp_out[hook(1, 2 + 3 * new_idx)] = y;
        kp_out[hook(1, 3 + 3 * new_idx)] = s;
      }
    }
  }
}