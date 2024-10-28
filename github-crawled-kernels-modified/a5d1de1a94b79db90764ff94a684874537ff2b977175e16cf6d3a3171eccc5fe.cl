//{"globsum":2,"histo":0,"temp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int changeTranspositionIndex(int i, int n) {
  int ip;

  ip = i;

  return ip;
}

kernel void kernel_ScanHistograms(global int* histo, local int* temp, global int* globsum) {
  size_t it = get_local_id(0);
  size_t ig = get_global_id(0);
  int decale = 1;
  size_t n = get_local_size(0) * 2;
  size_t gr = get_group_id(0);

  temp[hook(1, 2 * it)] = histo[hook(0, 2 * ig)];
  temp[hook(1, 2 * it + 1)] = histo[hook(0, 2 * ig + 1)];

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

  histo[hook(0, 2 * ig)] = temp[hook(1, 2 * it)];
  histo[hook(0, 2 * ig + 1)] = temp[hook(1, 2 * it + 1)];

  barrier(0x02);
}