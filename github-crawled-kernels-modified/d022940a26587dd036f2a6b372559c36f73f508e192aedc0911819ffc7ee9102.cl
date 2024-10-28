//{"col_ssd":5,"cols":3,"imageL":7,"input":0,"output":1,"prefilterCap":4,"rows":2,"ssd":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int CalcSSD(local unsigned int* col_ssd) {
  unsigned int cache = col_ssd[hook(5, 0)];

  for (int i = 1; i <= (64 << 1); i++)
    cache += col_ssd[hook(5, i)];

  return cache;
}

inline uint2 MinSSD(local unsigned int* col_ssd) {
  unsigned int ssd[8];
  const int win_size = (64 << 1);

  ssd[hook(6, 0)] = CalcSSD(col_ssd + 0 * (128 + win_size));
  ssd[hook(6, 1)] = CalcSSD(col_ssd + 1 * (128 + win_size));
  ssd[hook(6, 2)] = CalcSSD(col_ssd + 2 * (128 + win_size));
  ssd[hook(6, 3)] = CalcSSD(col_ssd + 3 * (128 + win_size));
  ssd[hook(6, 4)] = CalcSSD(col_ssd + 4 * (128 + win_size));
  ssd[hook(6, 5)] = CalcSSD(col_ssd + 5 * (128 + win_size));
  ssd[hook(6, 6)] = CalcSSD(col_ssd + 6 * (128 + win_size));
  ssd[hook(6, 7)] = CalcSSD(col_ssd + 7 * (128 + win_size));

  unsigned int mssd = min(min(min(ssd[hook(6, 0)], ssd[hook(6, 1)]), min(ssd[hook(6, 4)], ssd[hook(6, 5)])), min(min(ssd[hook(6, 2)], ssd[hook(6, 3)]), min(ssd[hook(6, 6)], ssd[hook(6, 7)])));

  int bestIdx = 0;

  for (int i = 0; i < 8; i++) {
    if (mssd == ssd[hook(6, i)])
      bestIdx = i;
  }

  return (uint2)(mssd, bestIdx);
}

inline void StepDown(int idx1, int idx2, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 imgR1 = convert_uint8(vload8(0, imageR + (idx1 - d - 7)));
  uint8 imgR2 = convert_uint8(vload8(0, imageR + (idx2 - d - 7)));
  uint8 diff1 = (uint8)(imageL[hook(7, idx1)]) - imgR1;
  uint8 diff2 = (uint8)(imageL[hook(7, idx2)]) - imgR2;
  uint8 res = diff2 * diff2 - diff1 * diff1;
  const int win_size = (64 << 1);
  col_ssd[hook(5, 0 * (128 + win_size))] += res.s7;
  col_ssd[hook(5, 1 * (128 + win_size))] += res.s6;
  col_ssd[hook(5, 2 * (128 + win_size))] += res.s5;
  col_ssd[hook(5, 3 * (128 + win_size))] += res.s4;
  col_ssd[hook(5, 4 * (128 + win_size))] += res.s3;
  col_ssd[hook(5, 5 * (128 + win_size))] += res.s2;
  col_ssd[hook(5, 6 * (128 + win_size))] += res.s1;
  col_ssd[hook(5, 7 * (128 + win_size))] += res.s0;
}

inline void InitColSSD(int x_tex, int y_tex, int im_pitch, global unsigned char* imageL, global unsigned char* imageR, int d, local unsigned int* col_ssd) {
  uint8 leftPixel1;
  uint8 diffa = 0;
  int idx = y_tex * im_pitch + x_tex;
  const int win_size = (64 << 1);
  for (int i = 0; i < (win_size + 1); i++) {
    leftPixel1 = (uint8)(imageL[hook(7, idx)]);
    uint8 imgR = convert_uint8(vload8(0, imageR + (idx - d - 7)));
    uint8 res = leftPixel1 - imgR;
    diffa += res * res;

    idx += im_pitch;
  }

  col_ssd[hook(5, 0 * (128 + win_size))] = diffa.s7;
  col_ssd[hook(5, 1 * (128 + win_size))] = diffa.s6;
  col_ssd[hook(5, 2 * (128 + win_size))] = diffa.s5;
  col_ssd[hook(5, 3 * (128 + win_size))] = diffa.s4;
  col_ssd[hook(5, 4 * (128 + win_size))] = diffa.s3;
  col_ssd[hook(5, 5 * (128 + win_size))] = diffa.s2;
  col_ssd[hook(5, 6 * (128 + win_size))] = diffa.s1;
  col_ssd[hook(5, 7 * (128 + win_size))] = diffa.s0;
}

kernel void prefilter_xsobel(global unsigned char* input, global unsigned char* output, int rows, int cols, int prefilterCap) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int cov = input[hook(0, (y - 1) * cols + (x - 1))] * (-1) + input[hook(0, (y - 1) * cols + (x + 1))] * (1) + input[hook(0, (y) * cols + (x - 1))] * (-2) + input[hook(0, (y) * cols + (x + 1))] * (2) + input[hook(0, (y + 1) * cols + (x - 1))] * (-1) + input[hook(0, (y + 1) * cols + (x + 1))] * (1);

    cov = min(min(max(-prefilterCap, cov), prefilterCap) + prefilterCap, 255);
    output[hook(1, y * cols + x)] = cov & 0xFF;
  }
}