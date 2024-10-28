//{"height":8,"lGrdX":6,"lImgB":2,"lImgG":1,"lImgR":0,"lcostVol":10,"rGrdX":7,"rImgB":5,"rImgG":4,"rImgR":3,"rcostVol":11,"width":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cvc_uchar_v16(global const uchar* lImgR, global const uchar* lImgG, global const uchar* lImgB, global const uchar* rImgR, global const uchar* rImgG, global const uchar* rImgB, global const uchar* lGrdX, global const uchar* rGrdX, const int height, const int width, global uchar* lcostVol, global uchar* rcostVol) {
  const int x = get_global_id(0) * 16;
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset = (y * width) + x;
  const int costVol_offset = ((d * height) + y) * width + x;

  uchar16 lCR = vload16(0, lImgR + offset);
  uchar16 lCG = vload16(0, lImgG + offset);
  uchar16 lCB = vload16(0, lImgB + offset);
  uchar16 lGX = vload16(0, lGrdX + offset);
  uchar16 rCR, rCG, rCB, rGX;

  ushort16 clrDiff, grdDiff;

  if (x - d >= 0) {
    rCR = vload16(0, rImgR + offset - d);
    rCG = vload16(0, rImgG + offset - d);
    rCB = vload16(0, rImgB + offset - d);
    rGX = vload16(0, rGrdX + offset - d);

    clrDiff = convert_ushort16(abs(lCR - rCR) + abs(lCG - rCG) + abs(lCB - rCB)) / (ushort)3;

    grdDiff = convert_ushort16(abs(lGX - rGX));
  } else {
    clrDiff = convert_ushort16(abs(lCR - (uchar16)255) + abs(lCG - (uchar16)255) + abs(lCB - (uchar16)255)) / (ushort)3;

    grdDiff = convert_ushort16(abs(lGX - (uchar16)255));
  }

  clrDiff = clrDiff > (ushort16)1835 ? (ushort16)1835 : clrDiff;
  grdDiff = grdDiff > (ushort16)524 ? (ushort16)524 : grdDiff;
  ushort16 cost = clrDiff / (ushort)9 * (ushort)10 + grdDiff / (ushort)10;
  vstore16(convert_uchar16(cost), 0, lcostVol + costVol_offset);

  lCR = vload16(0, rImgR + offset);
  lCG = vload16(0, rImgG + offset);
  lCB = vload16(0, rImgB + offset);
  lGX = vload16(0, rGrdX + offset);

  clrDiff = 0;
  grdDiff = 0;

  if (x + d < width) {
    rCR = vload16(0, lImgR + offset + d);
    rCG = vload16(0, lImgG + offset + d);
    rCB = vload16(0, lImgB + offset + d);
    rGX = vload16(0, lGrdX + offset + d);

    clrDiff = convert_ushort16(abs(lCR - rCR) + abs(lCG - rCG) + abs(lCB - rCB)) / (ushort)3;

    grdDiff = convert_ushort16(abs(lGX - rGX));
  } else {
    clrDiff = convert_ushort16(abs(lCR - (uchar16)255) + abs(lCG - (uchar16)255) + abs(lCB - (uchar16)255)) / (ushort)3;

    grdDiff = convert_ushort16(abs(lGX - (uchar16)255));
  }

  clrDiff = clrDiff > (ushort16)1835 ? (ushort16)1835 : clrDiff;
  grdDiff = grdDiff > (ushort16)524 ? (ushort16)524 : grdDiff;
  cost = clrDiff / (ushort)9 * (ushort)10 + grdDiff / (ushort)10;
  vstore16(convert_uchar16(cost), 0, rcostVol + costVol_offset);
}