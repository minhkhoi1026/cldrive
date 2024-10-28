//{"col_ssd":10,"cols":13,"cols_cache":9,"disp":0,"disp_cols":2,"disp_rows":1,"disp_step":3,"imageL":12,"input":4,"input_cols":6,"input_rows":5,"ssd":11,"threshold":8,"winsz":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int CalcSSD(local unsigned int* col_ssd) {
  unsigned int cache = col_ssd[hook(10, 0)];

  for (int i = 1; i <= (64 << 1); i++)
    cache += col_ssd[hook(10, i)];

  return cache;
}

inline uint2 MinSSD(local unsigned int* col_ssd) {
  unsigned int ssd[8];
  const int win_size = (64 << 1);

  ssd[hook(11, 0)] = CalcSSD(col_ssd + 0 * (128 + win_size));
  ssd[hook(11, 1)] = CalcSSD(col_ssd + 1 * (128 + win_size));
  ssd[hook(11, 2)] = CalcSSD(col_ssd + 2 * (128 + win_size));
  ssd[hook(11, 3)] = CalcSSD(col_ssd + 3 * (128 + win_size));
  ssd[hook(11, 4)] = CalcSSD(col_ssd + 4 * (128 + win_size));
  ssd[hook(11, 5)] = CalcSSD(col_ssd + 5 * (128 + win_size));
  ssd[hook(11, 6)] = CalcSSD(col_ssd + 6 * (128 + win_size));
  ssd[hook(11, 7)] = CalcSSD(col_ssd + 7 * (128 + win_size));

  unsigned int mssd = min(min(min(ssd[hook(11, 0)], ssd[hook(11, 1)]), min(ssd[hook(11, 4)], ssd[hook(11, 5)])), min(min(ssd[hook(11, 2)], ssd[hook(11, 3)]), min(ssd[hook(11, 6)], ssd[hook(11, 7)])));

  int bestIdx = 0;

  for (int i = 0; i < 8; i++) {
    if (mssd == ssd[hook(11, i)])
      bestIdx = i;
  }

  return (uint2)(mssd, bestIdx);
}

inline void StepDown(int idx1, int idx2, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 imgR1 = convert_uint8(vload8(0, imageR + (idx1 - d - 7)));
  uint8 imgR2 = convert_uint8(vload8(0, imageR + (idx2 - d - 7)));
  uint8 diff1 = (uint8)(imageL[hook(12, idx1)]) - imgR1;
  uint8 diff2 = (uint8)(imageL[hook(12, idx2)]) - imgR2;
  uint8 res = diff2 * diff2 - diff1 * diff1;
  const int win_size = (64 << 1);
  col_ssd[hook(10, 0 * (128 + win_size))] += res.s7;
  col_ssd[hook(10, 1 * (128 + win_size))] += res.s6;
  col_ssd[hook(10, 2 * (128 + win_size))] += res.s5;
  col_ssd[hook(10, 3 * (128 + win_size))] += res.s4;
  col_ssd[hook(10, 4 * (128 + win_size))] += res.s3;
  col_ssd[hook(10, 5 * (128 + win_size))] += res.s2;
  col_ssd[hook(10, 6 * (128 + win_size))] += res.s1;
  col_ssd[hook(10, 7 * (128 + win_size))] += res.s0;
}

inline void InitColSSD(int x_tex, int y_tex, int im_pitch, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 leftPixel1;
  uint8 diffa = 0;
  int idx = y_tex * im_pitch + x_tex;
  const int win_size = (64 << 1);
  for (int i = 0; i < (win_size + 1); i++) {
    leftPixel1 = (uint8)(imageL[hook(12, idx)]);
    uint8 imgR = convert_uint8(vload8(0, imageR + (idx - d - 7)));
    uint8 res = leftPixel1 - imgR;
    diffa += res * res;

    idx += im_pitch;
  }

  col_ssd[hook(10, 0 * (128 + win_size))] = diffa.s7;
  col_ssd[hook(10, 1 * (128 + win_size))] = diffa.s6;
  col_ssd[hook(10, 2 * (128 + win_size))] = diffa.s5;
  col_ssd[hook(10, 3 * (128 + win_size))] = diffa.s4;
  col_ssd[hook(10, 4 * (128 + win_size))] = diffa.s3;
  col_ssd[hook(10, 5 * (128 + win_size))] = diffa.s2;
  col_ssd[hook(10, 6 * (128 + win_size))] = diffa.s1;
  col_ssd[hook(10, 7 * (128 + win_size))] = diffa.s0;
}

inline float sobel(global unsigned char* input, int x, int y, int rows, int cols) {
  float conv = 0;
  int y1 = y == 0 ? 0 : y - 1;
  int x1 = x == 0 ? 0 : x - 1;
  if (x < cols && y < rows && x > 0 && y > 0) {
    conv = (float)input[hook(4, (y1) * cols + (x1))] * (-1) + (float)input[hook(4, (y1) * cols + (x + 1))] * (1) + (float)input[hook(4, (y) * cols + (x1))] * (-2) + (float)input[hook(4, (y) * cols + (x + 1))] * (2) + (float)input[hook(4, (y + 1) * cols + (x1))] * (-1) + (float)input[hook(4, (y + 1) * cols + (x + 1))] * (1);
  }
  return fabs(conv);
}

inline float CalcSums(local float* cols, local float* cols_cache, int winsz) {
  unsigned int cache = cols[hook(13, 0)];

  for (int i = 1; i <= winsz; i++)
    cache += cols[hook(13, i)];

  return cache;
}

kernel void textureness_kernel(global unsigned char* disp, int disp_rows, int disp_cols, int disp_step, global unsigned char* input, int input_rows, int input_cols, int winsz, float threshold, local float* cols_cache) {
  int winsz2 = winsz / 2;
  int n_dirty_pixels = (winsz2)*2;

  int local_id_x = get_local_id(0);
  int group_size_x = get_local_size(0);
  int group_id_y = get_group_id(1);

  local float* cols = cols_cache + group_size_x + local_id_x;
  local float* cols_extra = local_id_x < n_dirty_pixels ? cols + group_size_x : 0;

  int x = get_global_id(0);
  int beg_row = group_id_y * (2 * 21);
  int end_row = min(beg_row + (2 * 21), disp_rows);

  int y = beg_row;

  float sum = 0;
  float sum_extra = 0;

  for (int i = y - winsz2; i <= y + winsz2; ++i) {
    sum += sobel(input, x - winsz2, i, input_rows, input_cols);
    if (cols_extra)
      sum_extra += sobel(input, x + group_size_x - winsz2, i, input_rows, input_cols);
  }
  *cols = sum;
  if (cols_extra)
    *cols_extra = sum_extra;

  barrier(0x01);

  float sum_win = CalcSums(cols, cols_cache + local_id_x, winsz) * 255;
  if (sum_win < threshold)
    disp[hook(0, y * disp_step + x)] = 0;

  barrier(0x01);

  for (int y = beg_row + 1; y < end_row; ++y) {
    sum = sum - sobel(input, x - winsz2, y - winsz2 - 1, input_rows, input_cols) + sobel(input, x - winsz2, y + winsz2, input_rows, input_cols);
    *cols = sum;

    if (cols_extra) {
      sum_extra = sum_extra - sobel(input, x + group_size_x - winsz2, y - winsz2 - 1, input_rows, input_cols) + sobel(input, x + group_size_x - winsz2, y + winsz2, input_rows, input_cols);
      *cols_extra = sum_extra;
    }

    barrier(0x01);

    if (x < disp_cols) {
      float sum_win = CalcSums(cols, cols_cache + local_id_x, winsz) * 255;
      if (sum_win < threshold)
        disp[hook(0, y * disp_step + x)] = 0;
    }

    barrier(0x01);
  }
}