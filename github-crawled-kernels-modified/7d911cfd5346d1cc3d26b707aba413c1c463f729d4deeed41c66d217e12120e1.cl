//{"dt":4,"shift":3,"shiftFFT":2,"xFFT":0,"xRealSize":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void phase_shift(global float* xFFT, int xRealSize, global float* shiftFFT, float shift, float dt) {
  float a, b, c, d, omega;
  int i = get_global_id(0);
  if (i > xRealSize)
    return;

  a = xFFT[hook(0, 2 * i)];
  b = xFFT[hook(0, 2 * i + 1)];
  if (i == 0) {
    omega = 3.14159265358979323846f / dt;
    shiftFFT[hook(2, 0)] = a;
    shiftFFT[hook(2, 1)] = cos(omega * shift);
  } else {
    omega = i * (2 * 3.14159265358979323846f * shift) / (dt * xRealSize);
    c = cos(omega);
    d = sin(omega);
    shiftFFT[hook(2, 2 * i)] = a * c - b * d;
    shiftFFT[hook(2, 2 * i + 1)] = a * d + b * c;
  }
}