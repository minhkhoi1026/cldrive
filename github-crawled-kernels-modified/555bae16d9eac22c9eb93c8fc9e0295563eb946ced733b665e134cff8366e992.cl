//{"a":1,"b":2,"order":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose32(const int order, global float* a, global float* b) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  if ((i < order) && (j < order)) {
    b[hook(2, i * order + j)] += a[hook(1, j * order + i)];
    a[hook(1, j * order + i)] += 1.0f;
  }
}