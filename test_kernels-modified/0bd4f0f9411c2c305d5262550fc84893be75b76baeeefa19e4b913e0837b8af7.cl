//{"brpolja":1,"data":0,"output":3,"partial_sums":2,"x":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kraljice_brojac(global int* data, global int* brpolja, local float* partial_sums, global float* output) {
  int brP = 6;
  int k, ind;
  int x[6];

  int lid = get_local_id(0);

  partial_sums[hook(2, lid)] = 0.0;

  x[hook(4, 1)] = 0;
  k = 1;
  while (k > 0) {
    x[hook(4, k)]++;
    if (x[hook(4, k)] <= brP) {
      if (k == brP) {
        for (ind = 1; ind <= brP; ind++) {
          partial_sums[hook(2, lid)] += (float)x[hook(4, ind)];
        }

      } else {
        k++;
        x[hook(4, k)] = 0;
      }
    } else {
      k--;
    }
  }

  if (lid == 0) {
    output[hook(3, get_group_id(0))] = partial_sums[hook(2, lid)];
  }
}