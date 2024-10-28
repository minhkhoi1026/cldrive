//{"a":3,"alpha":0,"lda":4,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sger_no_inc(float alpha, global float* x, global float* y, global float* a, unsigned int lda) {
  const unsigned int ind_m = get_global_id(0);
  const unsigned int ind_n = get_global_id(1);

  const unsigned int index_a = ind_n * lda + ind_m;
  float this_a = a[hook(3, index_a)];
  float prod = x[hook(1, ind_m)] * y[hook(2, ind_n)];
  this_a = mad(alpha, prod, this_a);
  a[hook(3, index_a)] = this_a;
}