//{"a":4,"alpha":1,"incx":3,"lda":5,"uplo":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssyr_early_return(int uplo, float alpha, global float* x, unsigned int incx, global float* a, unsigned int lda) {
  const unsigned int ind_m = get_global_id(0);
  const unsigned int ind_n = get_global_id(1);

  const bool ltriangle = uplo == (1);

  const bool upper = ind_m < ind_n;
  const bool lower = ind_m > ind_n;

  if (ltriangle && upper)
    return;
  if (!ltriangle && lower)
    return;

  float left_x = x[hook(2, ind_m * incx)];
  float right_x = x[hook(2, ind_n * incx)];
  float this_a = a[hook(4, ((ind_n) * (lda) + (ind_m)))];
  float prod = left_x * right_x;
  this_a = mad(alpha, prod, this_a);
  a[hook(4, ((ind_n) * (lda) + (ind_m)))] = this_a;
}