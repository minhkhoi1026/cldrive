//{"brpolja":1,"data":0,"output":5,"partial_podaci":3,"partial_sums":2,"x":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduction_scalar(global int* data, global int* brpolja, local int* partial_sums, local int* partial_podaci, local int* x, global int* output) {
  int trenutno, j;
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int gsize = get_local_size(0);

  partial_podaci[hook(3, lid)] = data[hook(0, gid)];
  int polja = brpolja[hook(1, 0)];
  barrier(0x01);

  int koji = 0;
  int s = 0;
  for (int k = 0; k < gsize; k++) {
    trenutno = partial_podaci[hook(3, k)];
    j = polja;
    while (trenutno > 0) {
      x[hook(4, j)] = trenutno % 10;
      trenutno /= 10;
      j--;
    }

    int bre = 1;
    int i = 0;

    while (i < polja && bre == 1) {
      for (j = i + 1; j <= polja; j++) {
        if (!((x[hook(4, i)] == x[hook(4, j)]) || (abs(x[hook(4, i)] - x[hook(4, j)]) == abs(i - j)))) {
          if (j == polja && i == polja - 1) {
            partial_sums[hook(2, lid)] = partial_podaci[hook(3, k)];
          }
        } else {
          bre = 0;
        }
      }
      i++;
    }
    barrier(0x01);
  }

  if (lid == 0) {
    output[hook(5, get_group_id(0))] = partial_sums[hook(2, lid)];
  }
}