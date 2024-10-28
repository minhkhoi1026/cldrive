//{"N":1,"Y":0,"inverse":3,"twiddleFactors":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double2 rotateValue2(double2 value, double2 sinCos) {
  return (double2)(dot(value, (double2)(sinCos.y, -sinCos.x)), dot(value, sinCos));
}

kernel void cooleyTukeyFFT(global double2* Y, int N, global double2* twiddleFactors, int inverse) {
  int k = get_global_id(0);
  int halfN = N / 2;
  int offsetY = get_global_id(1) * N;

  double2 sinCos = twiddleFactors[hook(2, k)];
  if (inverse)
    sinCos.x = -sinCos.x;

  int o1 = offsetY + k;
  int o2 = o1 + halfN;
  double2 y1 = Y[hook(0, o1)];
  double2 y2 = Y[hook(0, o2)];

  double2 v = rotateValue2(y2, sinCos);
  Y[hook(0, o1)] = y1 + v;
  Y[hook(0, o2)] = y1 - v;
}