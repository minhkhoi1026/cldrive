//{"a":0,"n":1,"sum":2,"tmp_sum":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_local_kernel_def(global int* a, int n, global int* sum) {
  local int tmp_sum[256];
  int tid = get_local_id(0);
  int lsize = get_local_size(0);
  int i;

  tmp_sum[hook(3, tid)] = 0;
  for (i = tid; i < n; i += lsize)
    tmp_sum[hook(3, tid)] += a[hook(0, i)];

  if (lsize == 1) {
    if (tid == 0)
      *sum = tmp_sum[hook(3, 0)];
    return;
  }

  do {
    barrier(0x01);
    if (tid < lsize / 2) {
      int sum = tmp_sum[hook(3, tid)];
      if ((lsize & 1) && tid == 0)
        sum += tmp_sum[hook(3, tid + lsize - 1)];
      tmp_sum[hook(3, tid)] = sum + tmp_sum[hook(3, tid + lsize / 2)];
    }
    lsize = lsize / 2;
  } while (lsize);

  if (tid == 0)
    *sum = tmp_sum[hook(3, 0)];
}