//{"cols":3,"elements_per_row":7,"halfCols":5,"halfRows":6,"magno":1,"minDistance":8,"output":2,"parvo":0,"rows":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void processRetinaParvoMagnoMapping(global float* parvo, global float* magno, global float* output, const int cols, const int rows, const int halfCols, const int halfRows, const int elements_per_row, const float minDistance) {
  const int gidx = get_global_id(0), gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  const int offset = mad24(gidy, elements_per_row, gidx);

  float distanceToCenter = sqrt(((float)(gidy - halfRows) * (gidy - halfRows) + (gidx - halfCols) * (gidx - halfCols)));

  float a = distanceToCenter < minDistance ? (0.5f + 0.5f * (float)cos(3.1415926535897932384626433832795 * distanceToCenter / minDistance)) : 0;
  float b = 1.f - a;

  output[hook(2, offset)] = parvo[hook(0, offset)] * a + magno[hook(1, offset)] * b;
}