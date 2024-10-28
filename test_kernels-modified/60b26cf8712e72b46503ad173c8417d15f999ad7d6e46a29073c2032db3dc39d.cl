//{"nels":2,"s":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsmooth(global int* restrict s, global const int* restrict v, int nels) {
  const int i = get_global_id(0);
  if (i >= nels)
    return;
  int v1 = 0, v2 = v[hook(1, i)], v3 = 0;
  int c = 1;
  if (i > 0) {
    v1 = v[hook(1, i - 1)];
    ++c;
  }
  if (i + 1 < nels) {
    v3 = v[hook(1, i + 1)];
    ++c;
  }
  s[hook(0, i)] = (v1 + v2 + v3) / c;
}