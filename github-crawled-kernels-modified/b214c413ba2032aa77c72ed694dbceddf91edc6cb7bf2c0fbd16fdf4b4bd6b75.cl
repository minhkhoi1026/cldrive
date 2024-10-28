//{"inputImage":0,"outputImageDX":2,"outputImageDY":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel_no_vectors(global const uchar* restrict inputImage, const int width, global char* restrict outputImageDX, global char* restrict outputImageDY) {
  const int column = get_global_id(0);
  const int row = get_global_id(1);

  const int offset = row * width + column;

  uchar leftLoad = *(inputImage + (offset + 0));
  uchar middleLoad = *(inputImage + (offset + 1));
  uchar rightLoad = *(inputImage + (offset + 2));
  short leftData = convert_short(leftLoad);
  short middleData = convert_short(middleLoad);
  short rightData = convert_short(rightLoad);
  short dx = rightData - leftData;
  short dy = rightData + leftData + middleData * (short)2;

  leftLoad = *(inputImage + (offset + width * 1 + 0));
  rightLoad = *(inputImage + (offset + width * 1 + 2));

  leftData = convert_short(leftLoad);
  rightData = convert_short(rightLoad);

  dx += (rightData - leftData) * (short)2;

  leftLoad = *(inputImage + (offset + width * 2 + 0));
  middleLoad = *(inputImage + (offset + width * 2 + 1));
  rightLoad = *(inputImage + (offset + width * 2 + 2));

  leftData = convert_short(leftLoad);
  middleData = convert_short(middleLoad);
  rightData = convert_short(rightLoad);

  dx += rightData - leftData;
  dy -= rightData + leftData + middleData * (short)2;
  *(outputImageDX + offset + width + 1) = convert_char(dx >> 3);
  *(outputImageDY + offset + width + 1) = convert_char(dy >> 3);
}