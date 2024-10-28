//{"a":6,"alpha":1,"incx":3,"incy":5,"lda":7,"m":0,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sger_float4(unsigned int m, float alpha, global float* x, unsigned int incx, global float* y, unsigned int incy, global float* a, unsigned int lda) {
  lda /= 4;
  const unsigned int ind_m = get_global_id(0);
  const unsigned int ind_n = get_global_id(1);

  unsigned int index_a = ind_n * lda + ind_m;

  bool over = (ind_m + 1) * 4 > m;

  if (over) {
    index_a *= 4;
    float this_y = y[hook(4, ind_n * incy)];
    for (unsigned int row = ind_m * 4; row < m; row++) {
      float this_x = x[hook(2, row * incx)];
      float this_a = a[hook(6, index_a)];
      float prod = this_x * this_y;
      this_a = mad(alpha, prod, this_a);
      a[hook(6, index_a)] = this_a;
      index_a++;
    }

  } else {
    float4 this_x = (float4)((float2)(x[hook(2, (ind_m * 4 * incx))], x[hook(2, (ind_m * 4 * incx) + (incx))]), (float2)(x[hook(2, ((ind_m * 4 * incx) + 2 * (incx)))], x[hook(2, ((ind_m * 4 * incx) + 2 * (incx)) + (incx))]));
    float this_y = y[hook(4, ind_n * incy)];

    float4 this_a = vload4(index_a, a);
    float4 prod = (float4)this_y * this_x;
    this_a = mad((float4)alpha, prod, this_a);
    vstore4(this_a, index_a, a);
  }
}