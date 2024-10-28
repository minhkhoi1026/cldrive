//{"arr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample() {
  int arr[10];
  for (int i = 0; i < 10; i++)
    arr[hook(0, i)] = 0;
  int j = 0;
  do {
    arr[hook(0, j)] = 0;
  } while (j++ < 10);
}