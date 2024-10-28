//{"a":5,"alpha":2,"incx":4,"lda":6,"n":1,"uplo":0,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssyr_early_return_float4(int uplo, unsigned int n, float alpha, global float* x, unsigned int incx, global float* a, unsigned int lda) {
  const unsigned int ind_m = get_global_id(0) * (4);
  const unsigned int ind_n = get_global_id(1);

  const bool ltriangle = uplo == (1);

  const bool upper = ind_m + (4) - 1 < ind_n;
  const bool lower = ind_m > ind_n;

  if (ltriangle && upper)
    return;
  if (!ltriangle && lower)
    return;

  const bool diag = ind_m / (4) == ind_n / (4);
  const bool last_row = ind_m + (4) > n;

  float right_x = x[hook(3, ind_n * incx)];
  if (ltriangle && diag && last_row) {
    __attribute__((opencl_unroll_hint((4)))) for (int i = 0; i < (4); i++) {
      if (ind_m + i >= ind_n && ind_m + i < n) {
        float this_a = a[hook(5, ((ind_n) * (lda) + (ind_m + i)))];
        float left_x = x[hook(3, (ind_m + i) * incx)];
        float prod = left_x * right_x;
        this_a = mad(alpha, prod, this_a);
        a[hook(5, ((ind_n) * (lda) + (ind_m + i)))] = this_a;
      }
    }
  } else if (ltriangle && last_row) {
    __attribute__((opencl_unroll_hint((4)))) for (int i = 0; i < (4); i++) {
      if (ind_m + i < n) {
        float this_a = a[hook(5, ((ind_n) * (lda) + (ind_m + i)))];
        float left_x = x[hook(3, (ind_m + i) * incx)];
        float prod = left_x * right_x;
        this_a = mad(alpha, prod, this_a);
        a[hook(5, ((ind_n) * (lda) + (ind_m + i)))] = this_a;
      }
    }
  } else if (ltriangle && diag) {
    __attribute__((opencl_unroll_hint((4)))) for (int i = 0; i < (4); i++) {
      if (ind_m + i >= ind_n) {
        float this_a = a[hook(5, ((ind_n) * (lda) + (ind_m + i)))];
        float left_x = x[hook(3, (ind_m + i) * incx)];
        float prod = left_x * right_x;
        this_a = mad(alpha, prod, this_a);
        a[hook(5, ((ind_n) * (lda) + (ind_m + i)))] = this_a;
      }
    }
  } else if (!ltriangle && diag) {
    __attribute__((opencl_unroll_hint((4)))) for (int i = 0; i < (4); i++) {
      if (ind_m + i <= ind_n) {
        float this_a = a[hook(5, ((ind_n) * (lda) + (ind_m + i)))];
        float left_x = x[hook(3, (ind_m + i) * incx)];
        float prod = left_x * right_x;
        this_a = mad(alpha, prod, this_a);
        a[hook(5, ((ind_n) * (lda) + (ind_m + i)))] = this_a;
      }
    }
  } else {
    float4 left_x = (float4)(x[hook(3, ind_m * incx)], x[hook(3, ind_m * incx + incx)], x[hook(3, ind_m * incx + 2 * incx)], x[hook(3, ind_m * incx + 3 * incx)]);

    unsigned int index_a = ((ind_n) * (lda) + (ind_m));
    index_a /= (4);
    float4 this_a = vload4(index_a, a);
    float4 prod = left_x * (float4)right_x;
    this_a = mad((float4)alpha, prod, this_a);
    vstore4(this_a, index_a, a);
  }
}