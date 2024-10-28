//{"Dcache":14,"Lcache":15,"Ucache":16,"dd":4,"dl":3,"du":5,"ld":1,"ll":0,"lu":2,"m":12,"n":11,"smvf_cache":13,"ud":7,"ul":6,"uu":8,"x":9,"y":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void product_bmdv_q1_d(global double* ll, global double* ld, global double* lu, global double* dl, global double* dd, global double* du, global double* ul, global double* ud, global double* uu, global double* x, global double* y, unsigned long n, unsigned long m, local double* smvf_cache) {
  unsigned long idx = get_global_id(0);

  unsigned long lindex = get_local_id(0);

  local double* Dcache = smvf_cache;
  local double* Lcache = smvf_cache + get_local_size(0) + 2;
  local double* Ucache = smvf_cache + 2 * (get_local_size(0) + 2);

  Dcache[hook(14, lindex + 1)] = x[hook(9, idx)];
  if (idx >= m)
    Lcache[hook(15, lindex + 1)] = x[hook(9, idx - m)];
  if (idx + m < n)
    Ucache[hook(16, lindex + 1)] = x[hook(9, idx + m)];
  if (lindex == 0) {
    if (get_local_size(0) * get_group_id(0) - 1 < n)
      Dcache[hook(14, 0)] = x[hook(9, get_local_size(0) * get_group_id(0) - 1)];
    if (get_local_size(0) * get_group_id(0) - m - 1 < n)
      Lcache[hook(15, 0)] = x[hook(9, get_local_size(0) * get_group_id(0) - m - 1)];
    if (get_local_size(0) * get_group_id(0) + m - 1 < n)
      Ucache[hook(16, 0)] = x[hook(9, get_local_size(0) * get_group_id(0) + m - 1)];
  }
  if (lindex == get_local_size(0) - 1) {
    if (get_local_size(0) * (get_group_id(0) + 1) < n)
      Dcache[hook(14, get_local_size(0) + 1)] = x[hook(9, get_local_size(0) * (get_group_id(0) + 1))];
    if (get_local_size(0) * (get_group_id(0) + 1) - m < n)
      Lcache[hook(15, get_local_size(0) + 1)] = x[hook(9, get_local_size(0) * (get_group_id(0) + 1) - m)];
    if (get_local_size(0) * (get_group_id(0) + 1) + m < n)
      Ucache[hook(16, get_local_size(0) + 1)] = x[hook(9, get_local_size(0) * (get_group_id(0) + 1) + m)];
  }

  mem_fence(0x01);

  if (idx < n) {
    double ytemp1 = dd[hook(4, idx)] * Dcache[hook(14, lindex + 1)];
    if (idx > 0)
      ytemp1 += dl[hook(3, idx)] * Dcache[hook(14, lindex)];
    if (idx < n - 1)
      ytemp1 += du[hook(5, idx)] * Dcache[hook(14, lindex + 2)];

    if (idx > m)
      ytemp1 += ll[hook(0, idx)] * Lcache[hook(15, lindex)];
    if (idx > m - 1)
      ytemp1 += ld[hook(1, idx)] * Lcache[hook(15, lindex + 1)];
    if (idx > m - 2)
      ytemp1 += lu[hook(2, idx)] * Lcache[hook(15, lindex + 2)];

    if (idx < n - m + 1)
      ytemp1 += ul[hook(6, idx)] * Ucache[hook(16, lindex)];
    if (idx < n - m)
      ytemp1 += ud[hook(7, idx)] * Ucache[hook(16, lindex + 1)];
    if (idx < n - m - 1)
      ytemp1 += uu[hook(8, idx)] * Ucache[hook(16, lindex + 2)];
    y[hook(10, idx)] = ytemp1;
  }
}