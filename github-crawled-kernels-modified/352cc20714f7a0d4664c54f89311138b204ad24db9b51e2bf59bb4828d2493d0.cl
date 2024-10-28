//{"dt":4,"fft":0,"gaussVals":5,"gwidthFactor":3,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussianFilter(global const float* fft, global float* out, int n, float gwidthFactor, float dt, global float* gaussVals) {
  int i = get_global_id(0);
  if (2 * i >= n)
    return;

  float df = 1 / (n * dt);
  float omega;
  float gauss;
  if (i == 0) {
    gauss = 1;
  } else {
    omega = i * 2 * 3.14159265358979323846f * df;
    gauss = exp(-omega * omega / (4 * gwidthFactor * gwidthFactor));
  }
  out[hook(1, i * 2)] = fft[hook(0, i * 2)] * gauss;
  out[hook(1, i * 2 + 1)] = fft[hook(0, i * 2 + 1)] * gauss;
  out[hook(1, 2 * n - i * 2)] = fft[hook(0, 2 * n - i * 2)] * gauss;
  out[hook(1, 2 * n - i * 2 + 1)] = fft[hook(0, 2 * n - i * 2 + 1)] * gauss;
  gaussVals[hook(5, i)] = gauss;
}