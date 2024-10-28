//{"N":0,"twiddleFactors":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double2 rotateValue2(double2 value, double2 sinCos) {
  return (double2)(dot(value, (double2)(sinCos.y, -sinCos.x)), dot(value, sinCos));
}

kernel void cooleyTukeyFFTTwiddleFactors(int N, global double2* twiddleFactors) {
  int k = get_global_id(0);
  double param = -3.14159265358979323846f * 2 * k / (double)N;
  double c, s = sincos(param, &c);
  twiddleFactors[hook(1, k)] = (double2)(s, c);
}