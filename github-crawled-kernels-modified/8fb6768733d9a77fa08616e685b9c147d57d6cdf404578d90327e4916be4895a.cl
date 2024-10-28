//{"height":8,"lGrdX":6,"lImgB":2,"lImgG":1,"lImgR":0,"lcostVol":10,"rGrdX":7,"rImgB":5,"rImgG":4,"rImgR":3,"rcostVol":11,"width":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cvc_float_nv(global const float* lImgR, global const float* lImgG, global const float* lImgB, global const float* rImgR, global const float* rImgG, global const float* rImgB, global const float* lGrdX, global const float* rGrdX, const int height, const int width, global float* lcostVol, global float* rcostVol) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset = y * width + x;
  const int costVol_offset = ((d * height) + y) * width + x;

  float clrDiff, grdDiff;

  if (x >= d) {
    clrDiff = (fabs(lImgR[hook(0, offset)] - rImgR[hook(3, offset - d)]) + fabs(lImgG[hook(1, offset)] - rImgG[hook(4, offset - d)]) + fabs(lImgB[hook(2, offset)] - rImgB[hook(5, offset - d)])) / 3;

    grdDiff = fabs(lGrdX[hook(6, offset)] - rGrdX[hook(7, offset - d)]);
  } else {
    clrDiff = (fabs(lImgR[hook(0, offset)] - 1.0f) + fabs(lImgG[hook(1, offset)] - 1.0f) + fabs(lImgB[hook(2, offset)] - 1.0f)) / 3;

    grdDiff = fabs(lGrdX[hook(6, offset)] - 1.0f);
  }

  clrDiff = clrDiff > 0.028f ? 0.028f : clrDiff;
  grdDiff = grdDiff > 0.008f ? 0.008f : grdDiff;
  lcostVol[hook(10, costVol_offset)] = (0.9f * clrDiff + (1 - 0.9f) * grdDiff);

  clrDiff = 0;
  grdDiff = 0;

  if (x >= d) {
    clrDiff = (fabs(rImgR[hook(3, offset)] - lImgR[hook(0, offset + d)]) + fabs(rImgG[hook(4, offset)] - lImgG[hook(1, offset + d)]) + fabs(rImgB[hook(5, offset)] - lImgB[hook(2, offset + d)])) / 3;

    grdDiff = fabs(rGrdX[hook(7, offset)] - lGrdX[hook(6, offset + d)]);
  } else {
    clrDiff = (fabs(rImgR[hook(3, offset)] - 1.0f) + fabs(rImgG[hook(4, offset)] - 1.0f) + fabs(rImgB[hook(5, offset)] - 1.0f)) / 3;

    grdDiff = fabs(rGrdX[hook(7, offset)] - 1.0f);
  }

  clrDiff = clrDiff > 0.028f ? 0.028f : clrDiff;
  grdDiff = grdDiff > 0.008f ? 0.008f : grdDiff;
  rcostVol[hook(11, costVol_offset)] = (0.9f * clrDiff + (1 - 0.9f) * grdDiff);
}