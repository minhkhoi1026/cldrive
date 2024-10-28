//{"a":5,"alpha":0,"incx":2,"incy":4,"lda":6,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sger_naive(float alpha, global float* x, unsigned int incx, global float* y, unsigned int incy, global float* a, unsigned int lda) {
  const unsigned int ind_m = get_global_id(0);
  const unsigned int ind_n = get_global_id(1);

  const unsigned int index_a = ind_n * lda + ind_m;
  float this_a = a[hook(5, index_a)];
  float prod = x[hook(1, ind_m * incx)] * y[hook(3, ind_n * incy)];
  this_a = mad(alpha, prod, this_a);
  a[hook(5, index_a)] = this_a;
}