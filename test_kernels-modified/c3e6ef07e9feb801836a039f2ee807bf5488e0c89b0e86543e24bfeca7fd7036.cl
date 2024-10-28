//{"rasterParams":4,"resultLine":3,"scanLine1":0,"scanLine2":1,"scanLine3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void processNineCellWindow(global float* scanLine1, global float* scanLine2, global float* scanLine3, global float* resultLine, global float* rasterParams) {
  const int i = get_global_id(0);

  float x11 = scanLine1[hook(0, i)];
  float x21 = scanLine1[hook(0, i + 1)];
  float x31 = scanLine1[hook(0, i + 2)];
  float x12 = scanLine2[hook(1, i)];
  float x22 = scanLine2[hook(1, i + 1)];
  float x32 = scanLine2[hook(1, i + 2)];
  float x13 = scanLine3[hook(2, i)];
  float x23 = scanLine3[hook(2, i + 1)];
  float x33 = scanLine3[hook(2, i + 2)];

  if (x22 == rasterParams[hook(4, 0)]) {
    resultLine[hook(3, i)] = rasterParams[hook(4, 1)];
  } else {
    if (x11 == rasterParams[hook(4, 0)])
      x11 = x22;
    if (x12 == rasterParams[hook(4, 0)])
      x12 = x22;
    if (x13 == rasterParams[hook(4, 0)])
      x13 = x22;
    if (x21 == rasterParams[hook(4, 0)])
      x21 = x22;
    if (x23 == rasterParams[hook(4, 0)])
      x23 = x22;
    if (x31 == rasterParams[hook(4, 0)])
      x31 = x22;
    if (x32 == rasterParams[hook(4, 0)])
      x32 = x22;
    if (x33 == rasterParams[hook(4, 0)])
      x33 = x22;

    float diff1 = x11 - x22;
    float diff2 = x21 - x22;
    float diff3 = x31 - x22;
    float diff4 = x12 - x22;
    float diff5 = x32 - x22;
    float diff6 = x13 - x22;
    float diff7 = x23 - x22;
    float diff8 = x33 - x22;

    resultLine[hook(3, i)] = sqrt(diff1 * diff1 + diff2 * diff2 + diff3 * diff3 + diff4 * diff4 + diff5 * diff5 + diff6 * diff6 + diff7 * diff7 + diff8 * diff8);
  }
}