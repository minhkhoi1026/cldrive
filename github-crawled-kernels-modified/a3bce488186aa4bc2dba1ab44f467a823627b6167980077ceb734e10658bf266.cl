//{"height":8,"lGrdX":6,"lImgB":2,"lImgG":1,"lImgR":0,"lcostVol":10,"rGrdX":7,"rImgB":5,"rImgG":4,"rImgR":3,"rcostVol":11,"width":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cvc_uchar_nv(global const uchar* lImgR, global const uchar* lImgG, global const uchar* lImgB, global const uchar* rImgR, global const uchar* rImgG, global const uchar* rImgB, global const uchar* lGrdX, global const uchar* rGrdX, const int height, const int width, global uchar* lcostVol, global uchar* rcostVol) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset = y * width + x;
  const int costVol_offset = ((d * height) + y) * width + x;

  ushort clrDiff, grdDiff;

  if (x >= d) {
    clrDiff = (abs(lImgR[hook(0, offset)] - rImgR[hook(3, offset - d)]) + abs(lImgG[hook(1, offset)] - rImgG[hook(4, offset - d)]) + abs(lImgB[hook(2, offset)] - rImgB[hook(5, offset - d)])) / 3;

    grdDiff = abs(lGrdX[hook(6, offset)] - rGrdX[hook(7, offset - d)]);
  } else {
    clrDiff = (abs(lImgR[hook(0, offset)] - 255) + abs(lImgG[hook(1, offset)] - 255) + abs(lImgB[hook(2, offset)] - 255)) / 3;

    grdDiff = abs(lGrdX[hook(6, offset)] - 255);
  }

  clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
  grdDiff = grdDiff > 524 ? 524 : grdDiff;
  lcostVol[hook(10, costVol_offset)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);

  clrDiff = 0;
  grdDiff = 0;

  if (x >= d) {
    clrDiff = (abs(rImgR[hook(3, offset)] - lImgR[hook(0, offset + d)]) + abs(rImgG[hook(4, offset)] - lImgG[hook(1, offset + d)]) + abs(rImgB[hook(5, offset)] - lImgB[hook(2, offset + d)])) / 3;

    grdDiff = abs(rGrdX[hook(7, offset)] - lGrdX[hook(6, offset + d)]);
  } else {
    clrDiff = (abs(rImgR[hook(3, offset)] - 255) + abs(rImgG[hook(4, offset)] - 255) + abs(rImgB[hook(5, offset)] - 255)) / 3;

    grdDiff = abs(rGrdX[hook(7, offset)] - 255);
  }

  clrDiff = clrDiff > 1835 ? 1835 : clrDiff;
  grdDiff = grdDiff > 524 ? 524 : grdDiff;
  rcostVol[hook(11, costVol_offset)] = (uchar)(0.9f * clrDiff + (1 - 0.9f) * grdDiff);
}