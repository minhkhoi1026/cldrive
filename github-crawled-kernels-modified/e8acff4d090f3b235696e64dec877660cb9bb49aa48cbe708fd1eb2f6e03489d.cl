//{"start":1,"step":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillIndices(global float* x, float start, float step) {
  unsigned int id = get_global_id(0);
  x[hook(0, id)] = start + id * step;
}