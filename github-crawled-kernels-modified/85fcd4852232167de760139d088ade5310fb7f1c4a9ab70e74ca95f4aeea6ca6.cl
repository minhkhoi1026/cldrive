//{"nels":1,"v1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecinit(global int* restrict v1, int nels) {
  const int i = get_global_id(0);
  if (i >= nels)
    return;
  v1[hook(0, i)] = i;
}