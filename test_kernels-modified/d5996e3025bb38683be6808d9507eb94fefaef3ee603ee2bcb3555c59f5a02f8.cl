//{"N":2,"X":0,"Y":1,"factor":4,"offsetsX":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float2 rotateValue2(float2 value, float c, float s) {
  return (float2)(dot(value, (float2)(c, -s)), dot(value, (float2)(s, c)));
}

kernel void cooleyTukeyFFTCopy(global const float2* X, global float2* Y, int N, global const int* offsetsX, float factor) {
  int offsetY = get_global_id(0);
  if (offsetY >= N)
    return;

  int offsetX = offsetsX[hook(3, offsetY)];
  Y[hook(1, offsetY)] = X[hook(0, offsetX)] * factor;
}