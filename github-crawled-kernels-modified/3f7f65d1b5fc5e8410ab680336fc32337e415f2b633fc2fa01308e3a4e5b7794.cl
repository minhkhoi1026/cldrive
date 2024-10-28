//{"N":2,"dest":1,"src":0,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fftshift_1_f(global float* src, global float* dest, const int N, const int stride) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);

  int index1 = i + j * stride + k * stride * N;
  int index2 = i + (j + N / 2) * stride + k * stride * N;

  float val1 = src[hook(0, index1)];
  float val2 = src[hook(0, index2)];

  dest[hook(1, index1)] = val2;
  dest[hook(1, index2)] = val1;
}