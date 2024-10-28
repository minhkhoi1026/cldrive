//{"base":0,"lim0":3,"lim1":4,"n":1,"outBuffer":6,"simulationsBuffer":5,"window":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void phenCrowding(float base, unsigned int n, unsigned int window, unsigned int lim0, unsigned int lim1, global const float* simulationsBuffer, global float* outBuffer) {
  int gId0 = get_global_id(0);
  int gId1 = get_global_id(1);
  int lId0 = get_local_id(0);
  int lId1 = get_local_id(1);
  int gRefSimRow;
  int gTarSimRow;
  int gOutRow;
  int gOutRowRefl;

  float xySum = 0.0;
  float xSum = 0.0;
  float ySum = 0.0;
  float x2Sum = 0.0;
  float y2Sum = 0.0;
  float r = 0.0;

  if (gId0 >= gId1 && gId0 < lim0 && gId1 < lim1) {
    gRefSimRow = gId0 * n;
    gTarSimRow = gId1 * n;
    gOutRow = gId1 * lim0 + gId0;
    gOutRowRefl = gId0 * lim0 + gId1;

    if (gId0 != gId1 && gId0 < gId1 + window) {
      for (int i0 = 0; i0 < n; i0++) {
        xySum += simulationsBuffer[hook(5, gRefSimRow + i0)] * simulationsBuffer[hook(5, gTarSimRow + i0)];
        xSum += simulationsBuffer[hook(5, gRefSimRow + i0)];
        ySum += simulationsBuffer[hook(5, gTarSimRow + i0)];
        x2Sum += simulationsBuffer[hook(5, gRefSimRow + i0)] * simulationsBuffer[hook(5, gRefSimRow + i0)];
        y2Sum += simulationsBuffer[hook(5, gTarSimRow + i0)] * simulationsBuffer[hook(5, gTarSimRow + i0)];
      }
      r = (n * xySum - xSum * ySum) / (sqrt(n * x2Sum - xSum * xSum) * sqrt(n * y2Sum - ySum * ySum)) + 1.0;
    } else {
      r = 2.0;
    }

    if (gId0 != gId1) {
      outBuffer[hook(6, gOutRow)] = r;
      outBuffer[hook(6, gOutRowRefl)] = r;
    } else {
      outBuffer[hook(6, gOutRow)] = r;
    }
  }
}