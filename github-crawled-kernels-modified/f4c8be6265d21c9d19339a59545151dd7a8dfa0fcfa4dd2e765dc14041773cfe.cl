//{"a":0,"b":1,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_dmax_f32(global float* a, global float* b, const float threshold) {
  unsigned int i = get_global_id(0);
  if (a[hook(0, i)] > threshold) {
    b[hook(1, i)] = 1;
  } else {
    b[hook(1, i)] = 0;
  }
}