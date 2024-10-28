//{"alpha":1,"incx":3,"n":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 1, 1))) kernel void Sscal_packed(unsigned int n, float alpha, global float* x, unsigned int incx) {
  const unsigned int gid = get_global_id(0);
  unsigned int ind = gid * incx;
  const unsigned int max_ind = n * incx;
  const unsigned int gsz = get_global_size(0);
  const unsigned int inc = gsz * incx;

  __attribute__((opencl_unroll_hint(1))) for (unsigned int elem = 0; elem < 1; elem++) {
    x[hook(2, ind)] *= alpha;
    ind += inc;
  }

  while (ind < max_ind) {
    x[hook(2, ind)] *= alpha;
    ind += inc;
  }
}