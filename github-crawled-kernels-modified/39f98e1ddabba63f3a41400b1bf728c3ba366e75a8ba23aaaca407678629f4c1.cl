//{"cumsum":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClCumSum(global int* cumsum, int size) {
  int index = get_global_id(0);
  int global_size = get_global_size(0) * 2;
  int offset = 1;
  for (int d = global_size >> 1; d > 0; d >>= 1) {
    if (index < d) {
      int ai = offset * (2 * index + 1) - 1;
      int bi = offset * (2 * index + 2) - 1;

      cumsum[hook(0, bi)] += cumsum[hook(0, ai)];
    }
    offset *= 2;
    barrier(0x02);
  }

  int last_elem = cumsum[hook(0, global_size - 1)];

  if (index == 0)
    cumsum[hook(0, global_size - 1)] = 0;

  int d;
  for (d = 1; d < global_size / 2; d *= 2) {
    offset = offset >> 1;
    barrier(0x02);
    if (index < d) {
      int ai = (offset * ((2 * index) + 1)) - 1;
      int bi = (offset * ((2 * index) + 2)) - 1;

      int aux = cumsum[hook(0, ai)];
      cumsum[hook(0, ai)] = cumsum[hook(0, bi)];
      cumsum[hook(0, bi)] += aux;
    }
  }

  d *= 2;
  offset = offset >> 1;
  barrier(0x02);
  if (index == 0) {
  } else if (index < d) {
    int ai = (offset * ((2 * index) + 1)) - 1;
    int bi = (offset * ((2 * index) + 2)) - 1;
    int aux1 = cumsum[hook(0, ai)];
    int aux2 = cumsum[hook(0, bi)];

    barrier(0x02);

    cumsum[hook(0, ai - 1)] = aux2;
    cumsum[hook(0, bi - 1)] = aux2 + aux1;
  }
  cumsum[hook(0, global_size - 1)] = last_elem;
}