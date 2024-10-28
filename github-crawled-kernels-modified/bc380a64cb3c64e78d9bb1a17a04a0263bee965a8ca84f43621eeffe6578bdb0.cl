//{"dst":1,"size":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void desaturate(global const float* src, global float* dst, int size) {
  int idx = get_global_id(0);
  if (idx < size) {
    float r = src[hook(0, idx * 3)];
    float g = src[hook(0, idx * 3 + 1)];
    float b = src[hook(0, idx * 3 + 2)];

    float val = 0.2126f * r + 0.7152f * g + 0.0722f * b;
    dst[hook(1, idx * 3)] = dst[hook(1, idx * 3 + 1)] = dst[hook(1, idx * 3 + 2)] = val;
  }
}