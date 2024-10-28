//{"height":8,"lGrdX":6,"lImgB":2,"lImgG":1,"lImgR":0,"lcostVol":10,"rGrdX":7,"rImgB":5,"rImgG":4,"rImgR":3,"rcostVol":11,"width":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cvc_uchar_vx(global const uchar* lImgR, global const uchar* lImgG, global const uchar* lImgB, global const uchar* rImgR, global const uchar* rImgG, global const uchar* rImgB, global const uchar* lGrdX, global const uchar* rGrdX, const int height, const int width, global uchar* lcostVol, global uchar* rcostVol) {
  const int y = get_global_id(0);
  const int d = get_global_id(2);

  const int offset = y * width;
  const int costVol_offset = ((d * height) + y) * width;

  ushort clrDiff, grdDiff;

  for (int x = 0; x < d; x++) {
    clrDiff = (abs(lImgR[hook(0, offset + x)] - 255) + abs(lImgG[hook(1, offset + x)] - 255) + abs(lImgB[hook(2, offset + x)] - 255)) / 3;

    grdDiff = abs(lGrdX[hook(6, offset + x)] - 255);

    clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
    grdDiff = grdDiff > 524 ? 524 : grdDiff;
    lcostVol[hook(10, costVol_offset + x)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);
  }
  for (int x = d; x < width; x++) {
    clrDiff = (abs(lImgR[hook(0, offset + x)] - rImgR[hook(3, offset + x - d)]) + abs(lImgG[hook(1, offset + x)] - rImgG[hook(4, offset + x - d)]) + abs(lImgB[hook(2, offset + x)] - rImgB[hook(5, offset + x - d)])) / 3;

    grdDiff = abs(lGrdX[hook(6, offset + x)] - rGrdX[hook(7, offset + x - d)]);

    clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
    grdDiff = grdDiff > 524 ? 524 : grdDiff;
    lcostVol[hook(10, costVol_offset + x)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);
  }

  for (int x = 0; x < width - d; x++) {
    clrDiff = (abs(rImgR[hook(3, offset + x)] - lImgR[hook(0, offset + x + d)]) + abs(rImgG[hook(4, offset + x)] - lImgG[hook(1, offset + x + d)]) + abs(rImgB[hook(5, offset + x)] - lImgB[hook(2, offset + x + d)])) * 0.333f;

    grdDiff = abs(rGrdX[hook(7, offset)] - lGrdX[hook(6, offset + x + d)]);

    clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
    grdDiff = grdDiff > 524 ? 524 : grdDiff;
    rcostVol[hook(11, costVol_offset + x)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);
  }
  for (int x = width - d; x < width; x++) {
    clrDiff = (abs(rImgR[hook(3, offset + x)] - 255) + abs(rImgG[hook(4, offset + x)] - 255) + abs(rImgB[hook(5, offset + x)] - 255)) * 0.333f;

    grdDiff = abs(rGrdX[hook(7, offset + x)] - 255);

    clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
    grdDiff = grdDiff > 524 ? 524 : grdDiff;
    rcostVol[hook(11, costVol_offset + x)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);
  }
}