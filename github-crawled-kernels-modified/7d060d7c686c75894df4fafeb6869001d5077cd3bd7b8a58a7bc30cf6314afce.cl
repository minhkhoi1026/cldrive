//{"inputImage":0,"outputImageDX":2,"outputImageDY":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(global const uchar* restrict inputImage, const int width, global char* restrict outputImageDX, global char* restrict outputImageDY) {
  const int column = get_global_id(0) * 16;
  const int row = get_global_id(1) * 1;

  const int offset = row * width + column;
  uchar16 leftLoad = vload16(0, inputImage + (offset + 0));
  uchar16 middleLoad = vload16(0, inputImage + (offset + 1));
  uchar16 rightLoad = vload16(0, inputImage + (offset + 2));
  short16 leftData = convert_short16(leftLoad);
  short16 middleData = convert_short16(middleLoad);
  short16 rightData = convert_short16(rightLoad);
  short16 dx = rightData - leftData;
  short16 dy = rightData + leftData + middleData * (short)2;

  leftLoad = vload16(0, inputImage + (offset + width * 1 + 0));
  rightLoad = vload16(0, inputImage + (offset + width * 1 + 2));

  leftData = convert_short16(leftLoad);
  rightData = convert_short16(rightLoad);

  dx += (rightData - leftData) * (short)2;

  leftLoad = vload16(0, inputImage + (offset + width * 2 + 0));
  middleLoad = vload16(0, inputImage + (offset + width * 2 + 1));
  rightLoad = vload16(0, inputImage + (offset + width * 2 + 2));

  leftData = convert_short16(leftLoad);
  middleData = convert_short16(middleLoad);
  rightData = convert_short16(rightLoad);

  dx += rightData - leftData;
  dy -= rightData + leftData + middleData * (short)2;
  vstore16(convert_char16(dx >> 3), 0, outputImageDX + offset + width + 1);
  vstore16(convert_char16(dy >> 3), 0, outputImageDY + offset + width + 1);
}