//{"afft":0,"bfft":1,"n":3,"outfft":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate(global const float* afft, global const float* bfft, global float* outfft, int n) {
  int i = get_global_id(0);
  if (i >= n / 2)
    return;

  if (i == 0) {
    outfft[hook(2, 0)] = afft[hook(0, 0)] * bfft[hook(1, 0)];
    outfft[hook(2, 1)] = afft[hook(0, 1)] * bfft[hook(1, 1)];
  } else {
    outfft[hook(2, i)] = afft[hook(0, i)] * bfft[hook(1, i)] + afft[hook(0, i + 1)] * bfft[hook(1, i + 1)];
    outfft[hook(2, i + 1)] = afft[hook(0, i + 1)] * bfft[hook(1, i)] - afft[hook(0, i)] * bfft[hook(1, i + 1)];
  }
}