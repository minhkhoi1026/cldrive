//{"N":2,"X":0,"Y":1,"factor":4,"offsetsX":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double2 rotateValue2(double2 value, double2 sinCos) {
  return (double2)(dot(value, (double2)(sinCos.y, -sinCos.x)), dot(value, sinCos));
}

kernel void cooleyTukeyFFTCopy(global const double2* X, global double2* Y, int N, global const int* offsetsX, double factor) {
  int offsetY = get_global_id(0);
  if (offsetY >= N)
    return;

  int offsetX = offsetsX[hook(3, offsetY)];
  Y[hook(1, offsetY)] = X[hook(0, offsetX)] * factor;
}