//{"a":0,"n":1,"sum":3,"tmp_sum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_sum(global int* a, int n, global int* tmp_sum, global int* sum) {
  int tid = get_local_id(0);
  int lsize = get_local_size(0);
  int i;

  tmp_sum[hook(2, tid)] = 0;
  for (i = tid; i < n; i += lsize)
    tmp_sum[hook(2, tid)] += a[hook(0, i)];

  for (i = hadd(lsize, 1); lsize > 1; i = hadd(i, 1)) {
    barrier(0x02);
    if (tid + i < lsize)
      tmp_sum[hook(2, tid)] += tmp_sum[hook(2, tid + i)];
    lsize = i;
  }

  if (tid == 0)
    *sum = tmp_sum[hook(2, 0)];
}