//{"a":0,"b":1,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_min_f32(global float* a, global float* b, const float threshold) {
  unsigned int i = get_global_id(0);
  b[hook(1, i)] = min(threshold, a[hook(0, i)]);
}