//{"a":1,"b":2,"da":4,"db":5,"dc":7,"ds":6,"n":0,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void weighted_delta_kernel(int n, global float* a, global float* b, global float* s, global float* da, global float* db, global float* ds, global float* dc) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n) {
    if (da)
      da[hook(4, i)] += dc[hook(7, i)] * s[hook(3, i)];
    if (db)
      db[hook(5, i)] += dc[hook(7, i)] * (1 - s[hook(3, i)]);
    ds[hook(6, i)] += dc[hook(7, i)] * (a[hook(1, i)] - b[hook(2, i)]);
  }
}