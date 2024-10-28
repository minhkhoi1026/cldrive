//{"nels":2,"v1":0,"v2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecinit(global int* restrict v1, global int* restrict v2, int nels) {
  const int i = get_global_id(0);

  if (i >= nels)
    return;

  v1[hook(0, i)] = i;
  v2[hook(1, i)] = nels - i;
}