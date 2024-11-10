//{"diffThresh":2,"image":0,"nCumLevels":5,"nHueLevels":3,"nSumLevels":4,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
int4 convertPixelToHMMD2(int R, int G, int B) {
  int max, min;
  float hue;

  max = R;
  if (max < G) {
    max = G;
  }
  if (max < B) {
    max = B;
  }

  min = R;
  if (min > G) {
    min = G;
  }
  if (min > B) {
    min = B;
  }

  if (max == min)
    hue = -1;

  else {
    if (R == max)
      hue = ((G - B) * 60.0f / (float)(max - min));

    else if (G == max)
      hue = (120.0f + (B - R) * 60.0f / (float)(max - min));

    else if (B == max)
      hue = (240.0f + (R - G) * 60.0f / (float)(max - min));

    if (hue < 0.0f)
      hue += 360.0f;
  }
  return (int4)((int)(hue + 0.5f), (int)(max + min + 1) >> 1, (int)(max - min + 0.5), 0);
}
int4 convertPixelToHMMD(int R, int G, int B) {
  float hue;
  int a, D;

  if (R < G) {
    if (G < B) {
      a = B + R;
      D = B - R;
      hue = 240.0f + ((float)(R - G)) * 60.0f / D;
    } else {
      if (R < B) {
        a = G + R;
        D = G - R;
        hue = 120.0f + ((float)(B - R)) * 60.0f / D;
      } else {
        a = G + B;
        D = G - B;
        hue = 120.0f + ((float)(B - R)) * 60.0f / D;
      }
    }
    if (hue < 0.0f) {
      hue += 360.0f;
    }
  } else {
    if (B < R) {
      if (B < G) {
        a = R + B;
        D = R - B;
        hue = (((float)(G - B)) * 60.0f / D);
      } else {
        a = R + G;
        D = R - G;
        hue = (((float)(G - B)) * 60.0f / D);
      }
      if (hue < 0.0f) {
        hue += 360.0f;
      }
    } else {
      if (G < B) {
        a = B + G;
        D = B - G;
        hue = (240.0f + ((float)(R - G)) * 60.0f / D);
        if (hue < 0.0f) {
          hue += 360.0f;
        }
      } else {
        return (int4)(0, (G + G + 1) >> 1, 0, 0);
      }
    }
  }
  return (int4)((int)(hue + 0.5f), (a + 1) >> 1, D, 0);
}
int quantizeHMMDPixel(int4 px, constant short* diffThresh, constant uchar* nHueLevels, constant uchar* nSumLevels, constant uchar* nCumLevels) {
  int H = px.x;
  int S = px.y;
  int D = px.z;

  int iSub = 0;

  while (diffThresh[hook(2, iSub + 1)] <= D)
    iSub++;

  int Hindex = (int)((H / 360.0f) * nHueLevels[hook(3, iSub)]);

  if (H == 360.0f)
    Hindex = 0.0f;

  short curDiffThresh = diffThresh[hook(2, iSub)];
  uchar curSumLevel = nSumLevels[hook(4, iSub)];

  int Sindex = (int)(((float)S - 0.5f * curDiffThresh) * curSumLevel / (255.0f - curDiffThresh));

  if (Sindex >= curSumLevel)
    Sindex = curSumLevel - 1;

  return nCumLevels[hook(5, iSub)] + Hindex * curSumLevel + Sindex;
}
kernel void imageToHMMDQuants(read_only image2d_t image, write_only image2d_t output, constant short* diffThresh, constant uchar* nHueLevels, constant uchar* nSumLevels, constant uchar* nCumLevels) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);
  int2 dims = get_image_dim(image);
  if (x >= dims.x || y >= dims.y) {
    return;
  }
  int2 coord = (int2)(x, y);
  int4 px = read_imagei(image, sampler, coord);
  int R, G, B;
  R = px.x;
  G = px.y;
  B = px.z;
  int4 hmmd = convertPixelToHMMD(R, G, B);
  int result = quantizeHMMDPixel(hmmd, diffThresh, nHueLevels, nSumLevels, nCumLevels);
  write_imageui(output, coord, result);
}