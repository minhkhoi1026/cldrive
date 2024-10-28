//{"N":3,"dir":5,"in":0,"numCols":2,"numRowsToProcess":4,"startRow":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clFFT_1DTwistInterleaved(global float2* in, unsigned int startRow, unsigned int numCols, unsigned int N, unsigned int numRowsToProcess, int dir) {
  float2 a, w;
  float ang;
  unsigned int j;
  unsigned int i = get_global_id(0);
  unsigned int startIndex = i;
  if (i < numCols) {
    for (j = 0; j < numRowsToProcess; j++) {
      a = in[hook(0, startIndex)];
      ang = 2.0f * 3.14159265358979323846f * dir * i * (startRow + j) / N;
      w = (float2)(native_cos(ang), native_sin(ang));
      a = ((float2)(mad(-(a).y, (w).y, (a).x * (w).x), mad((a).y, (w).x, (a).x * (w).y)));
      in[hook(0, startIndex)] = a;
      startIndex += numCols;
    }
  }
}