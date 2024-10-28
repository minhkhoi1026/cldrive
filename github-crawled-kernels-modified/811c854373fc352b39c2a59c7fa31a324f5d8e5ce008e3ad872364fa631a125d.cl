//{"dst":3,"lxx":0,"lxy":1,"lyy":2,"sigma":4,"size":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AKAZE_compute_determinant(global const float* lxx, global const float* lxy, global const float* lyy, global float* dst, float sigma, int size) {
  int i = get_global_id(0);

  if (!(i < size)) {
    return;
  }

  dst[hook(3, i)] = (lxx[hook(0, i)] * lyy[hook(2, i)] - lxy[hook(1, i)] * lxy[hook(1, i)]) * sigma;
}