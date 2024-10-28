//{"cache":7,"krn":3,"krn_h":5,"krn_w":4,"output":6,"src":0,"src_h":2,"src_w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_local_float(const global float* src, const int src_w, const int src_h, const global float* krn, const private int krn_w, const private int krn_h, global float* output, local float* cache) {
  const int half_krn_w = krn_w / 2;
  const int half_krn_h = krn_h / 2;

  const int X = get_global_id(0);
  const int Y = get_global_id(1);
  const int W = get_global_size(0);

  const int LX = get_local_id(0);
  const int LY = get_local_id(1);
  const int LW = get_local_size(0);
  const int LH = get_local_size(1);

  const int CW = LW + 2 * half_krn_w;
  const int CH = LH + 2 * half_krn_h;

  if (X >= src_w || Y >= src_h) {
    barrier(0x01);
    return;
  }
  const global float* src_it = src + X - half_krn_w + (Y - half_krn_h) * W;
  local float* cache_it = cache;
  if (LX == 0 && LY == 0) {
    for (int j = 0; j < CH; j++) {
      int r = Y + j - half_krn_h;
      for (int i = 0; i < CW; i++) {
        int c = X + i - half_krn_w;
        if (c >= 0 && c < src_w && r >= 0 && r < src_h) {
          *cache_it = *src_it;
        } else {
          *cache_it = 0;
        }
        src_it++;
        cache_it++;
      }
      src_it += W - CW;
    }
  }
  barrier(0x01);

  const global float* krn_ptr = krn + krn_w * krn_h - 1;
  const local float* cache_ptr = cache + LX + LY * CW;
  float sum = 0;
  for (int j = 0; j < krn_h; j++) {
    int r = Y + j - half_krn_h;
    for (int i = 0; i < krn_w; i++) {
      int c = X + i - half_krn_w;
      if (c >= 0 && c < src_w && r >= 0 && r < src_h) {
        sum += *cache_ptr * *krn_ptr;
      }
      cache_ptr++;
      krn_ptr--;
    }
    cache_ptr += CW - krn_w;
  }

  output[hook(6, X + Y * W)] = sum;
}