//{"in":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort_test(global long* in, int n) {
  int id = get_global_id(0);
  if (id >= n)
    return;

  for (int j = id + 1; j < n; j++) {
    if (in[hook(0, id)] > in[hook(0, j)]) {
      int temp = in[hook(0, id)];
      in[hook(0, id)] = in[hook(0, j)];
      in[hook(0, j)] = temp;
    }
  }
}