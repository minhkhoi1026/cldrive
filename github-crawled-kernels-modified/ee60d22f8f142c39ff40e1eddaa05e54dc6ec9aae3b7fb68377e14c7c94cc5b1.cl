//{"cheight":7,"cminSSDImage":2,"cminSSD_step":3,"col_ssd":11,"col_ssd_cache":10,"cwidth":6,"disp":4,"disp_step":5,"disparImage":15,"imageL":13,"img_step":8,"left":0,"maxdisp":9,"minSSDImage":14,"right":1,"ssd":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int CalcSSD(local unsigned int* col_ssd) {
  unsigned int cache = col_ssd[hook(11, 0)];

  for (int i = 1; i <= (64 << 1); i++)
    cache += col_ssd[hook(11, i)];

  return cache;
}

inline uint2 MinSSD(local unsigned int* col_ssd) {
  unsigned int ssd[8];
  const int win_size = (64 << 1);

  ssd[hook(12, 0)] = CalcSSD(col_ssd + 0 * (128 + win_size));
  ssd[hook(12, 1)] = CalcSSD(col_ssd + 1 * (128 + win_size));
  ssd[hook(12, 2)] = CalcSSD(col_ssd + 2 * (128 + win_size));
  ssd[hook(12, 3)] = CalcSSD(col_ssd + 3 * (128 + win_size));
  ssd[hook(12, 4)] = CalcSSD(col_ssd + 4 * (128 + win_size));
  ssd[hook(12, 5)] = CalcSSD(col_ssd + 5 * (128 + win_size));
  ssd[hook(12, 6)] = CalcSSD(col_ssd + 6 * (128 + win_size));
  ssd[hook(12, 7)] = CalcSSD(col_ssd + 7 * (128 + win_size));

  unsigned int mssd = min(min(min(ssd[hook(12, 0)], ssd[hook(12, 1)]), min(ssd[hook(12, 4)], ssd[hook(12, 5)])), min(min(ssd[hook(12, 2)], ssd[hook(12, 3)]), min(ssd[hook(12, 6)], ssd[hook(12, 7)])));

  int bestIdx = 0;

  for (int i = 0; i < 8; i++) {
    if (mssd == ssd[hook(12, i)])
      bestIdx = i;
  }

  return (uint2)(mssd, bestIdx);
}

inline void StepDown(int idx1, int idx2, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 imgR1 = convert_uint8(vload8(0, imageR + (idx1 - d - 7)));
  uint8 imgR2 = convert_uint8(vload8(0, imageR + (idx2 - d - 7)));
  uint8 diff1 = (uint8)(imageL[hook(13, idx1)]) - imgR1;
  uint8 diff2 = (uint8)(imageL[hook(13, idx2)]) - imgR2;
  uint8 res = diff2 * diff2 - diff1 * diff1;
  const int win_size = (64 << 1);
  col_ssd[hook(11, 0 * (128 + win_size))] += res.s7;
  col_ssd[hook(11, 1 * (128 + win_size))] += res.s6;
  col_ssd[hook(11, 2 * (128 + win_size))] += res.s5;
  col_ssd[hook(11, 3 * (128 + win_size))] += res.s4;
  col_ssd[hook(11, 4 * (128 + win_size))] += res.s3;
  col_ssd[hook(11, 5 * (128 + win_size))] += res.s2;
  col_ssd[hook(11, 6 * (128 + win_size))] += res.s1;
  col_ssd[hook(11, 7 * (128 + win_size))] += res.s0;
}

inline void InitColSSD(int x_tex, int y_tex, int im_pitch, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 leftPixel1;
  uint8 diffa = 0;
  int idx = y_tex * im_pitch + x_tex;
  const int win_size = (64 << 1);
  for (int i = 0; i < (win_size + 1); i++) {
    leftPixel1 = (uint8)(imageL[hook(13, idx)]);
    uint8 imgR = convert_uint8(vload8(0, imageR + (idx - d - 7)));
    uint8 res = leftPixel1 - imgR;
    diffa += res * res;

    idx += im_pitch;
  }

  col_ssd[hook(11, 0 * (128 + win_size))] = diffa.s7;
  col_ssd[hook(11, 1 * (128 + win_size))] = diffa.s6;
  col_ssd[hook(11, 2 * (128 + win_size))] = diffa.s5;
  col_ssd[hook(11, 3 * (128 + win_size))] = diffa.s4;
  col_ssd[hook(11, 4 * (128 + win_size))] = diffa.s3;
  col_ssd[hook(11, 5 * (128 + win_size))] = diffa.s2;
  col_ssd[hook(11, 6 * (128 + win_size))] = diffa.s1;
  col_ssd[hook(11, 7 * (128 + win_size))] = diffa.s0;
}

kernel void stereoKernel(global unsigned char* left, global unsigned char* right, global unsigned int* cminSSDImage, int cminSSD_step, global unsigned char* disp, int disp_step, int cwidth, int cheight, int img_step, int maxdisp, local unsigned int* col_ssd_cache) {
  local unsigned int* col_ssd = col_ssd_cache + get_local_id(0);
  local unsigned int* col_ssd_extra = get_local_id(0) < (64 << 1) ? col_ssd + 128 : 0;

  int X = get_group_id(0) * 128 + get_local_id(0) + maxdisp + 64;

  global unsigned int* minSSDImage = cminSSDImage + X + (int)(get_group_id(1) * 21 + 64) * cminSSD_step;
  global unsigned char* disparImage = disp + X + (int)(get_group_id(1) * 21 + 64) * disp_step;

  int end_row = 21 < (cheight - (int)(get_group_id(1) * 21 + 64)) ? 21 : (cheight - (int)(get_group_id(1) * 21 + 64));
  int y_tex;
  int x_tex = X - 64;

  for (int d = 0; d < maxdisp; d += 8) {
    y_tex = (int)(get_group_id(1) * 21 + 64) - 64;

    InitColSSD(x_tex, y_tex, img_step, left, right, d, col_ssd);
    if (col_ssd_extra > 0)
      if (x_tex + 128 < cwidth)
        InitColSSD(x_tex + 128, y_tex, img_step, left, right, d, col_ssd_extra);

    barrier(0x01);

    uint2 minSSD = MinSSD(col_ssd);
    if (X < cwidth - 64 && (int)(get_group_id(1) * 21 + 64) < cheight - 64) {
      if (minSSD.x < minSSDImage[hook(14, 0)]) {
        disparImage[hook(15, 0)] = (unsigned char)(d + minSSD.y);
        minSSDImage[hook(14, 0)] = minSSD.x;
      }
    }

    for (int row = 1; row < end_row; row++) {
      int idx1 = y_tex * img_step + x_tex;
      int idx2 = min(y_tex + ((64 << 1) + 1), cheight - 1) * img_step + x_tex;

      barrier(0x01);

      StepDown(idx1, idx2, left, right, d, col_ssd);
      if (col_ssd_extra > 0)
        if (x_tex + 128 < cwidth)
          StepDown(idx1, idx2, left + 128, right + 128, d, col_ssd_extra);

      barrier(0x01);

      uint2 minSSD = MinSSD(col_ssd);
      if (X < cwidth - 64 && row < cheight - 64 - (int)(get_group_id(1) * 21 + 64)) {
        int idx = row * cminSSD_step;
        if (minSSD.x < minSSDImage[hook(14, idx)]) {
          disparImage[hook(15, disp_step * row)] = (unsigned char)(d + minSSD.y);
          minSSDImage[hook(14, idx)] = minSSD.x;
        }
      }

      y_tex++;
    }
  }
}