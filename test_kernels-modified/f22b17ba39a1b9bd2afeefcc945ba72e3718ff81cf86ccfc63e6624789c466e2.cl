//{"fft":0,"shortFft":1,"shortLen":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void shortenFFT(global const float* fft, global float* shortFft, int shortLen) {
  int i = get_global_id(0);
  float f = fft[hook(0, i)];
  if (i < shortLen) {
    if (i == 1) {
      shortFft[hook(1, shortLen / 2)] = fft[hook(0, shortLen)];
    } else if (i % 2 == 0) {
      shortFft[hook(1, i / 2)] = f;
    } else {
      shortFft[hook(1, shortLen - (i + 1) / 2)] = f;
    }
  }
  if (i = 0) {
    shortFft[hook(1, shortLen / 2)] = fft[hook(0, shortLen)];
  }
}