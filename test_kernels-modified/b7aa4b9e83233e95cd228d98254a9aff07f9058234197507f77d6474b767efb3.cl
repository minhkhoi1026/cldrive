//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BitonicSortParallel(global int* a, global int* b) {
  int id = get_global_id(0);
  int i = b[hook(1, 2)];
  int j = b[hook(1, 3)];

  int dist = 1;

  int p;

  for (p = 0; p < j; p++) {
    dist = dist * 2;
  }

  int k = id + ((int)id / dist) * dist;

  int z = 1;

  for (p = 0; p < i + 1; p++) {
    z = z * 2;
  }

  int r = (int)(k / z);
  int pari = r % 2;

  if (((int)(a[hook(0, k)] > a[hook(0, k + dist)]) + pari) == 1) {
    int tmp = a[hook(0, k)];
    a[hook(0, k)] = a[hook(0, k + dist)];
    a[hook(0, k + dist)] = tmp;
  }
}