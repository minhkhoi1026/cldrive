//{"Dcache":15,"Lcache":16,"Ucache":17,"dd":4,"dl":3,"du":5,"ld":1,"ll":0,"lu":2,"m":13,"n":12,"rhs":9,"smvf_cache":14,"ud":7,"ul":6,"uu":8,"x":10,"y":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void defect_q1_f(global float* ll, global float* ld, global float* lu, global float* dl, global float* dd, global float* du, global float* ul, global float* ud, global float* uu, global float* rhs, global float* x, global float* y, unsigned long n, unsigned long m, local float* smvf_cache) {
  unsigned long idx = get_global_id(0);

  unsigned long lindex = get_local_id(0);

  local float* Dcache = smvf_cache;
  local float* Lcache = smvf_cache + get_local_size(0) + 2;
  local float* Ucache = smvf_cache + 2 * (get_local_size(0) + 2);

  Dcache[hook(15, lindex + 1)] = x[hook(10, idx)];
  if (idx >= m)
    Lcache[hook(16, lindex + 1)] = x[hook(10, idx - m)];
  if (idx + m < n)
    Ucache[hook(17, lindex + 1)] = x[hook(10, idx + m)];
  if (lindex == 0) {
    if (get_local_size(0) * get_group_id(0) - 1 < n)
      Dcache[hook(15, 0)] = x[hook(10, get_local_size(0) * get_group_id(0) - 1)];
    if (get_local_size(0) * get_group_id(0) - m - 1 < n)
      Lcache[hook(16, 0)] = x[hook(10, get_local_size(0) * get_group_id(0) - m - 1)];
    if (get_local_size(0) * get_group_id(0) + m - 1 < n)
      Ucache[hook(17, 0)] = x[hook(10, get_local_size(0) * get_group_id(0) + m - 1)];
  }
  if (lindex == get_local_size(0) - 1) {
    if (get_local_size(0) * (get_group_id(0) + 1) < n)
      Dcache[hook(15, get_local_size(0) + 1)] = x[hook(10, get_local_size(0) * (get_group_id(0) + 1))];
    if (get_local_size(0) * (get_group_id(0) + 1) - m < n)
      Lcache[hook(16, get_local_size(0) + 1)] = x[hook(10, get_local_size(0) * (get_group_id(0) + 1) - m)];
    if (get_local_size(0) * (get_group_id(0) + 1) + m < n)
      Ucache[hook(17, get_local_size(0) + 1)] = x[hook(10, get_local_size(0) * (get_group_id(0) + 1) + m)];
  }

  mem_fence(0x01);

  if (idx < n) {
    float ytemp1 = dd[hook(4, idx)] * Dcache[hook(15, lindex + 1)];
    if (idx > 0)
      ytemp1 += dl[hook(3, idx)] * Dcache[hook(15, lindex)];
    if (idx < n - 1)
      ytemp1 += du[hook(5, idx)] * Dcache[hook(15, lindex + 2)];

    if (idx > m)
      ytemp1 += ll[hook(0, idx)] * Lcache[hook(16, lindex)];
    if (idx > m - 1)
      ytemp1 += ld[hook(1, idx)] * Lcache[hook(16, lindex + 1)];
    if (idx > m - 2)
      ytemp1 += lu[hook(2, idx)] * Lcache[hook(16, lindex + 2)];

    if (idx < n - m + 1)
      ytemp1 += ul[hook(6, idx)] * Ucache[hook(17, lindex)];
    if (idx < n - m)
      ytemp1 += ud[hook(7, idx)] * Ucache[hook(17, lindex + 1)];
    if (idx < n - m - 1)
      ytemp1 += uu[hook(8, idx)] * Ucache[hook(17, lindex + 2)];
    y[hook(11, idx)] = rhs[hook(9, idx)] - ytemp1;
  }
}