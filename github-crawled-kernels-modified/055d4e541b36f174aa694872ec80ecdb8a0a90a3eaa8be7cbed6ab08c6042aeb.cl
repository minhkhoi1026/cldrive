//{"approxOut":1,"decomLevels":9,"dest":3,"details":2,"hardThresh":10,"inputUVOffset":6,"inputYOffset":4,"layer":8,"outputUVOffset":7,"outputYOffset":5,"softThresh":11,"src":0,"src_p":12,"threshConst":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float threshConst[5] = {50.430166f, 20.376415f, 10.184031f, 6.640919f, 3.367972f};

kernel void kernel_wavelet_denoise(global unsigned int* src, global unsigned int* approxOut, global float* details, global unsigned int* dest, int inputYOffset, int outputYOffset, unsigned int inputUVOffset, unsigned int outputUVOffset, int layer, int decomLevels, float hardThresh, float softThresh) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  size_t width = get_global_size(0);
  size_t height = get_global_size(1);

  int imageWidth = width * 16;
  int imageHeight = height;

  float stdev = 0.0f;
  float thold = 0.0f;
  float16 deviation = (float16)0.0f;

  layer = (layer > 1) ? layer : 1;
  layer = (layer < decomLevels) ? layer : decomLevels;

  src += inputYOffset;
  dest += outputYOffset;

  int xScaler = pown(2.0f, (layer - 1));
  int yScaler = xScaler;

  xScaler = ((x == 0) || (x > imageWidth / 16 - xScaler)) ? 0 : xScaler;
  yScaler = ((y < yScaler) || (y > imageHeight - yScaler)) ? 0 : yScaler;

  uint4 approx;
  float16 detail;

  global uchar* src_p = (global uchar*)(src);

  int pixel_index = x * 16 + y * imageWidth;
  int group_index = x * 4 + y * (imageWidth / 4);

  uint4 chroma;
  int chroma_index = x * 4 + (y / 2) * (imageWidth / 4);

  ushort16 a;
  ushort16 b;
  ushort16 c;
  ushort16 d;
  ushort16 e;
  ushort16 f;
  ushort16 g;
  ushort16 h;
  ushort16 i;

  float div = 1.0f / 16.0f;

  a = (ushort16)(convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth - xScaler + 15)]));

  b = (ushort16)(convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 1)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 2)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 3)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 4)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 5)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 6)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 7)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 8)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 9)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 10)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 11)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 12)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 13)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 14)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + 15)]));

  c = (ushort16)(convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index - yScaler * imageWidth + xScaler + 15)]));

  d = (ushort16)(convert_ushort(src_p[hook(12, pixel_index - xScaler)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index - xScaler + 15)]));

  e = (ushort16)(convert_ushort(src_p[hook(12, pixel_index)]), convert_ushort(src_p[hook(12, pixel_index + 1)]), convert_ushort(src_p[hook(12, pixel_index + 2)]), convert_ushort(src_p[hook(12, pixel_index + 3)]), convert_ushort(src_p[hook(12, pixel_index + 4)]), convert_ushort(src_p[hook(12, pixel_index + 5)]), convert_ushort(src_p[hook(12, pixel_index + 6)]), convert_ushort(src_p[hook(12, pixel_index + 7)]), convert_ushort(src_p[hook(12, pixel_index + 8)]), convert_ushort(src_p[hook(12, pixel_index + 9)]), convert_ushort(src_p[hook(12, pixel_index + 10)]), convert_ushort(src_p[hook(12, pixel_index + 11)]), convert_ushort(src_p[hook(12, pixel_index + 12)]), convert_ushort(src_p[hook(12, pixel_index + 13)]), convert_ushort(src_p[hook(12, pixel_index + 14)]), convert_ushort(src_p[hook(12, pixel_index + 15)]));

  f = (ushort16)(convert_ushort(src_p[hook(12, pixel_index + xScaler)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index + xScaler + 15)]));

  g = (ushort16)(convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth - xScaler + 15)]));

  h = (ushort16)(convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 1)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 2)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 3)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 4)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 5)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 6)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 7)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 8)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 9)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 10)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 11)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 12)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 13)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 14)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + 15)]));

  i = (ushort16)(convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 1)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 2)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 3)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 4)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 5)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 6)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 7)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 8)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 9)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 10)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 11)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 12)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 13)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 14)]), convert_ushort(src_p[hook(12, pixel_index + yScaler * imageWidth + xScaler + 15)]));

  ushort16 sum;
  sum = (ushort16)1 * a + (ushort16)2 * b + (ushort16)1 * c + (ushort16)2 * d + (ushort16)4 * e + (ushort16)2 * f + (ushort16)1 * g + (ushort16)2 * h + (ushort16)1 * i;

  approx = __builtin_astype((convert_uchar16(((convert_float16(sum) + 0.5f / div) * div))), uint4);
  detail = convert_float16(convert_char16(e) - __builtin_astype((approx), char16));

  thold = hardThresh * threshConst[hook(13, layer - 1)];

  detail = (detail < -thold) ? detail + (thold - thold * softThresh) : detail;
  detail = (detail > thold) ? detail - (thold - thold * softThresh) : detail;
  detail = (detail > -thold && detail < thold) ? detail * softThresh : detail;

  global float16* details_p = (global float16*)(&details[hook(2, pixel_index)]);
  if (layer == 1) {
    (*details_p) = detail;
    if (y % 2 == 0) {
      chroma = vload4(0, src + chroma_index + inputUVOffset * (imageWidth / 4));
      vstore4(chroma, 0, dest + chroma_index + outputUVOffset * (imageWidth / 4));
    }

  } else {
    (*details_p) += detail;
  }

  if (layer < decomLevels) {
    (*(global uint4*)(approxOut + group_index)) = approx;

  } else {
    global uint4* dest_p = (global uint4*)(&dest[hook(3, group_index)]);
    (*dest_p) = __builtin_astype((convert_uchar16(*details_p + convert_float16(__builtin_astype((approx), uchar16)))), uint4);
  }
}