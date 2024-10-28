//{"_img":0,"d":9,"img":8,"img_cols":4,"img_offset":2,"img_rows":3,"kp_loc":5,"max_keypoints":6,"step":1,"threshold":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int cornerScore(global const uchar* img, int step) {
  int k, tofs, v = img[hook(8, 0)], a0 = 0, b0;
  int d[16];

  tofs = 3;
  d[hook(9, 0)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 0 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step + 3;
  d[hook(9, 1)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 1 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step * 2 + 2;
  d[hook(9, 2)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 2 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step * 3 + 1;
  d[hook(9, 3)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 3 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step * 3;
  d[hook(9, 4)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 4 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step * 3 - 1;
  d[hook(9, 5)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 5 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step * 2 - 2;
  d[hook(9, 6)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 6 + 8)] = (short)(v - img[hook(8, -tofs)]);
  tofs = -step - 3;
  d[hook(9, 7)] = (short)(v - img[hook(8, tofs)]);
  d[hook(9, 7 + 8)] = (short)(v - img[hook(8, -tofs)]);

  for (k = 0; k < 16; k += 2) {
    int a = min((int)d[hook(9, (k + 1) & 15)], (int)d[hook(9, (k + 2) & 15)]);
    a = min(a, (int)d[hook(9, (k + 3) & 15)]);
    a = min(a, (int)d[hook(9, (k + 4) & 15)]);
    a = min(a, (int)d[hook(9, (k + 5) & 15)]);
    a = min(a, (int)d[hook(9, (k + 6) & 15)]);
    a = min(a, (int)d[hook(9, (k + 7) & 15)]);
    a = min(a, (int)d[hook(9, (k + 8) & 15)]);
    a0 = max(a0, min(a, (int)d[hook(9, k & 15)]));
    a0 = max(a0, min(a, (int)d[hook(9, (k + 9) & 15)]));
  }

  b0 = -a0;
  for (k = 0; k < 16; k += 2) {
    int b = max((int)d[hook(9, (k + 1) & 15)], (int)d[hook(9, (k + 2) & 15)]);
    b = max(b, (int)d[hook(9, (k + 3) & 15)]);
    b = max(b, (int)d[hook(9, (k + 4) & 15)]);
    b = max(b, (int)d[hook(9, (k + 5) & 15)]);
    b = max(b, (int)d[hook(9, (k + 6) & 15)]);
    b = max(b, (int)d[hook(9, (k + 7) & 15)]);
    b = max(b, (int)d[hook(9, (k + 8) & 15)]);

    b0 = min(b0, max(b, (int)d[hook(9, k)]));
    b0 = min(b0, max(b, (int)d[hook(9, (k + 9) & 15)]));
  }

  return -b0 - 1;
}

kernel void FAST_findKeypoints(global const uchar* _img, int step, int img_offset, int img_rows, int img_cols, volatile global int* kp_loc, int max_keypoints, int threshold) {
  int j = get_global_id(0) + 3;
  int i = get_global_id(1) + 3;

  if (i < img_rows - 3 && j < img_cols - 3) {
    global const uchar* img = _img + mad24(i, step, j + img_offset);
    int v = img[hook(8, 0)], t0 = v - threshold, t1 = v + threshold;
    int k, tofs, v0, v1;
    int m0 = 0, m1 = 0;

    tofs = 3;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 0) | ((v1 < t0) << (8 + 0));
    m1 |= ((v0 > t1) << 0) | ((v1 > t1) << (8 + 0));
    if ((m0 | m1) == 0)
      return;

    tofs = -step * 2 + 2;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 2) | ((v1 < t0) << (8 + 2));
    m1 |= ((v0 > t1) << 2) | ((v1 > t1) << (8 + 2));
    tofs = -step * 3;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 4) | ((v1 < t0) << (8 + 4));
    m1 |= ((v0 > t1) << 4) | ((v1 > t1) << (8 + 4));
    tofs = -step * 2 - 2;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 6) | ((v1 < t0) << (8 + 6));
    m1 |= ((v0 > t1) << 6) | ((v1 > t1) << (8 + 6));

    if (((m0 | (m0 >> 8)) & (1 + 4 + 16 + 64)) != (1 + 4 + 16 + 64) && ((m1 | (m1 >> 8)) & (1 + 4 + 16 + 64)) != (1 + 4 + 16 + 64))
      return;

    tofs = -step + 3;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 1) | ((v1 < t0) << (8 + 1));
    m1 |= ((v0 > t1) << 1) | ((v1 > t1) << (8 + 1));
    tofs = -step * 3 + 1;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 3) | ((v1 < t0) << (8 + 3));
    m1 |= ((v0 > t1) << 3) | ((v1 > t1) << (8 + 3));
    tofs = -step * 3 - 1;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 5) | ((v1 < t0) << (8 + 5));
    m1 |= ((v0 > t1) << 5) | ((v1 > t1) << (8 + 5));
    tofs = -step - 3;
    v0 = img[hook(8, tofs)];
    v1 = img[hook(8, -tofs)];
    m0 |= ((v0 < t0) << 7) | ((v1 < t0) << (8 + 7));
    m1 |= ((v0 > t1) << 7) | ((v1 > t1) << (8 + 7));
    if (((m0 | (m0 >> 8)) & 255) != 255 && ((m1 | (m1 >> 8)) & 255) != 255)
      return;

    m0 |= m0 << 16;
    m1 |= m1 << 16;

    if (((m0 & (511 << 0)) == (511 << 0)) + ((m0 & (511 << 1)) == (511 << 1)) + ((m0 & (511 << 2)) == (511 << 2)) + ((m0 & (511 << 3)) == (511 << 3)) + ((m0 & (511 << 4)) == (511 << 4)) + ((m0 & (511 << 5)) == (511 << 5)) + ((m0 & (511 << 6)) == (511 << 6)) + ((m0 & (511 << 7)) == (511 << 7)) + ((m0 & (511 << 8)) == (511 << 8)) + ((m0 & (511 << 9)) == (511 << 9)) + ((m0 & (511 << 10)) == (511 << 10)) + ((m0 & (511 << 11)) == (511 << 11)) + ((m0 & (511 << 12)) == (511 << 12)) + ((m0 & (511 << 13)) == (511 << 13)) + ((m0 & (511 << 14)) == (511 << 14)) + ((m0 & (511 << 15)) == (511 << 15)) +

            ((m1 & (511 << 0)) == (511 << 0)) + ((m1 & (511 << 1)) == (511 << 1)) + ((m1 & (511 << 2)) == (511 << 2)) + ((m1 & (511 << 3)) == (511 << 3)) + ((m1 & (511 << 4)) == (511 << 4)) + ((m1 & (511 << 5)) == (511 << 5)) + ((m1 & (511 << 6)) == (511 << 6)) + ((m1 & (511 << 7)) == (511 << 7)) + ((m1 & (511 << 8)) == (511 << 8)) + ((m1 & (511 << 9)) == (511 << 9)) + ((m1 & (511 << 10)) == (511 << 10)) + ((m1 & (511 << 11)) == (511 << 11)) + ((m1 & (511 << 12)) == (511 << 12)) + ((m1 & (511 << 13)) == (511 << 13)) + ((m1 & (511 << 14)) == (511 << 14)) + ((m1 & (511 << 15)) == (511 << 15)) ==
        0)
      return;

    {
      int idx = atomic_inc(kp_loc);
      if (idx < max_keypoints) {
        kp_loc[hook(5, 1 + 2 * idx)] = j;
        kp_loc[hook(5, 2 + 2 * idx)] = i;
      }
    }
  }
}