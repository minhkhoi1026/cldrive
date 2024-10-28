//{"globsum":2,"histograms":0,"temp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan(global unsigned int* histograms, local unsigned int* temp, global unsigned int* globsum) {
  int it = get_local_id(0);
  int ig = get_global_id(0);
  int decale = 1;
  int n = get_local_size(0) * 2;
  int gr = get_group_id(0);

  temp[hook(1, 2 * it)] = histograms[hook(0, 2 * ig)];
  temp[hook(1, 2 * it + 1)] = histograms[hook(0, 2 * ig + 1)];

  for (int d = n >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (it < d) {
      int ai = decale * (2 * it + 1) - 1;
      int bi = decale * (2 * it + 2) - 1;
      temp[hook(1, bi)] += temp[hook(1, ai)];
    }

    decale *= 2;
  }

  if (it == 0) {
    globsum[hook(2, gr)] = temp[hook(1, n - 1)];
    temp[hook(1, n - 1)] = 0;
  }

  for (int d = 1; d < n; d *= 2) {
    decale >>= 1;
    barrier(0x01);

    if (it < d) {
      int ai = decale * (2 * it + 1) - 1;
      int bi = decale * (2 * it + 2) - 1;

      int t = temp[hook(1, ai)];
      temp[hook(1, ai)] = temp[hook(1, bi)];
      temp[hook(1, bi)] += t;
    }
  }

  barrier(0x01);

  histograms[hook(0, 2 * ig)] = temp[hook(1, 2 * it)];
  histograms[hook(0, 2 * ig + 1)] = temp[hook(1, 2 * it + 1)];

  barrier(0x02);
}