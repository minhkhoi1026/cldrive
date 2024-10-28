//{"v":0,"v2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void doubleGrayScaleDoubleChar(global double* v, global char* v2) {
  unsigned int i = get_global_id(0);
  if (i % 3 == 0) {
    v[hook(0, i)] = v[hook(0, i)];
    v[hook(0, i + 1)] = v[hook(0, i)];
    v[hook(0, i + 2)] = v[hook(0, i)];
    v2[hook(1, i)] = v2[hook(1, i)];
    v2[hook(1, i + 1)] = v2[hook(1, i)];
    v2[hook(1, i + 2)] = v2[hook(1, i)];
  }
}