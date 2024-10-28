//{"input":0,"output":1,"r":3,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spoc_max(global const double* input, global double* output, const int size) {
  int i = get_global_id(0);
  if (i > 1)
    return;
  const int NB_THREADS = 256;
  local double r[NB_THREADS];
  double res = 0;
  r[hook(3, i)] = input[hook(0, (size / NB_THREADS * i))];
  for (int j = (size / NB_THREADS * i); j < (size / NB_THREADS * (i + 1)); j++) {
    if (r[hook(3, i)] < fabs(input[hook(0, j)]))
      r[hook(3, i)] = fabs(input[hook(0, j)]);
  }
  barrier(0x01);
  res = r[hook(3, 0)];
  if (i == 0)
    for (int j = 1; j < NB_THREADS; j++) {
      if (res < (r[hook(3, j)]))
        res = (r[hook(3, j)]);
    }
  output[hook(1, 0)] = res;
}