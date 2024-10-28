//{"height":3,"imageData":0,"mask":1,"newImageData":5,"numElements":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int isValidImageIndex(int idx, int numElements) {
  return (idx >= 0 && idx < numElements);
}

inline int isTransparencyNotColor(int idx) {
  return (idx % 4) == 3;
}

inline uchar make8Bit(int val) {
  if (val < 0) {
    val = 0;
  }
  if (val > 255) {
    val = 255;
  }
  return (uchar)val;
}

kernel void convolve(global uchar* imageData, global int* mask, int width, int height, int numElements, global uchar* newImageData) {
  int centerIdx = get_global_id(0);
  int sum = 0;

  for (int dx = -1; dx <= 1; dx++) {
    for (int dy = -1; dy <= 1; dy++) {
      int idx = centerIdx + (4 * width * dy) + (4 * dx);
      idx = isValidImageIndex(idx, numElements) ? idx : centerIdx;
      int scaleFromMask = mask[hook(1, (dy + 1) * 3 + (dx + 1))];
      sum += ((int)imageData[hook(0, idx)]) * scaleFromMask;
    }
  }

  if (isTransparencyNotColor(centerIdx)) {
    sum = (uchar)255;
  }

  newImageData[hook(5, centerIdx)] = make8Bit(sum);
}