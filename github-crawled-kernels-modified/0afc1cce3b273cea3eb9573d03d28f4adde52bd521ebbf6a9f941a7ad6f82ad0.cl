//{"in":0,"length":2,"out":1,"sign":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dft(global const double2* in, global double2* out, int length, int sign) {
  int i = get_global_id(0);

  if (i >= length)
    return;

  double2 tot = 0;
  double param = (-2 * sign * i) * 3.14159265358979323846f / (double)length;

  for (int k = 0; k < length; k++) {
    double2 value = in[hook(0, k)];

    double c;
    double s = sincos(k * param, &c);

    tot += (double2)(dot(value, (double2)(c, -s)), dot(value, (double2)(s, c)));
  }

  if (sign == 1) {
    out[hook(1, i)] = tot;
  } else {
    out[hook(1, i)] = tot / (double)length;
  }
}