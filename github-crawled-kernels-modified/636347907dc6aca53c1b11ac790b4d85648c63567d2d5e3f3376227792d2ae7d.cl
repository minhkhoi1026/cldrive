//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BitonicSortParallel(global int* a, global int* b) {
  int id = get_global_id(0);
  int num_thread = get_global_size(0);

  int thread_work = (int)(b[hook(1, 0)] / (num_thread * 2));

  int i;
  int j;
  int l;

  for (i = 0; i < b[hook(1, 1)]; i++) {
    for (j = i; j > -1; j--) {
      int dist = 1;

      int p;

      for (p = 0; p < j; p++) {
        dist = dist * 2;
      }

      for (l = 0; l < thread_work; l++) {
        int map_id = num_thread * l + id;

        int k = map_id + ((int)map_id / dist) * dist;

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

      barrier(0x01);
    }
  }
}