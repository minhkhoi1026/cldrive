//{"A":2,"acc":9,"alpha":1,"beta":6,"incx":5,"incy":8,"lda":3,"n":0,"x":4,"y":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void Ssymv_opt_locgr_1_upper(unsigned int n, float alpha, global float* A, unsigned int lda, global float* x, int incx, float beta, global float* y, int incy) {
  unsigned int local_id = get_local_id(0);

  local float acc[256];
  acc[hook(9, local_id)] = 0.f;

  float thread_x_value;

  if (local_id < n)
    thread_x_value = x[hook(4, local_id * incx)];

  __attribute__((opencl_unroll_hint)) for (unsigned int row_id = 0; row_id < n; ++row_id) {
    if (local_id < n) {
      if (row_id <= local_id)
        acc[hook(9, local_id)] = A[hook(2, local_id * lda + row_id)] * thread_x_value;
      else
        acc[hook(9, local_id)] = A[hook(2, row_id * lda + local_id)] * thread_x_value;
    }

    barrier(0x01);

    __attribute__((opencl_unroll_hint)) for (unsigned int offset = 256 / 2; offset > 0; offset = offset / 2) {
      if (local_id < offset) {
        float val_1 = acc[hook(9, local_id + offset)];
        float val_2 = acc[hook(9, local_id)];

        acc[hook(9, local_id)] = val_1 + val_2;
      }
      barrier(0x01);
    }

    barrier(0x01);

    if (local_id == 0) {
      if (beta != 0)
        y[hook(7, row_id * incy)] = fma(alpha, acc[hook(9, 0)], beta * y[hook(7, row_id * incy)]);
      else
        y[hook(7, row_id * incy)] = alpha * acc[hook(9, 0)];
    }
  }
}