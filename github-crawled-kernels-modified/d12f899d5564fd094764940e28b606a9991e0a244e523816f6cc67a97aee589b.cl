//{"Aj":2,"Ap":1,"Ax":3,"num_rows":0,"p_Aj":7,"p_Ax":6,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void csr(const unsigned int num_rows, global const unsigned int* restrict Ap, global const unsigned int* restrict Aj, global const float* restrict Ax, constant float* restrict x, global float* restrict y) {
 private
  size_t row = get_global_id(0);

  if (row < num_rows) {
   private
    float sum = y[hook(5, row)];

   private
    const unsigned int row_start = Ap[hook(1, row)];
   private
    const unsigned int row_end = Ap[hook(1, row + 1)];

   private
    size_t jj, ii, kk;
   private
    float p_Ax[12];
   private
    unsigned int p_Aj[12];
    for (jj = row_start; jj < row_end; jj = jj + 12) {
      if (jj + 12 - 1 < row_end) {
        for (ii = 0; ii < 12; ii++)
          p_Ax[hook(6, ii)] = Ax[hook(3, jj + ii)];

        for (ii = 0; ii < 12; ii++)
          p_Aj[hook(7, ii)] = Aj[hook(2, jj + ii)];

        sum = ((((((sum) + (p_Ax[hook(6, 0)] * x[hook(4, p_Aj[0hook(7, 0))])) + ((p_Ax[hook(6, 1)] * x[hook(4, p_Aj[1hook(7, 1))]) + (p_Ax[hook(6, 2)] * x[hook(4, p_Aj[2hook(7, 2))]))) + (((p_Ax[hook(6, 3)] * x[hook(4, p_Aj[3hook(7, 3))]) + (p_Ax[hook(6, 4)] * x[hook(4, p_Aj[4hook(7, 4))])) + ((p_Ax[hook(6, 5)] * x[hook(4, p_Aj[5hook(7, 5))]) + (p_Ax[hook(6, 6)] * x[hook(4, p_Aj[6hook(7, 6))])))) + ((((p_Ax[hook(6, 7)] * x[hook(4, p_Aj[7hook(7, 7))]) + (p_Ax[hook(6, 8)] * x[hook(4, p_Aj[8hook(7, 8))])) + ((p_Ax[hook(6, 9)] * x[hook(4, p_Aj[9hook(7, 9))]) + (p_Ax[hook(6, 10)] * x[hook(4, p_Aj[1hook(7, 10))]))) + (((p_Ax[hook(6, 11)] * x[hook(4, p_Aj[1hook(7, 11))]) + (p_Ax[hook(6, 12)] * x[hook(4, p_Aj[1hook(7, 12))])) + ((p_Ax[hook(6, 13)] * x[hook(4, p_Aj[1hook(7, 13))]) + (p_Ax[hook(6, 14)] * x[hook(4, p_Aj[1hook(7, 14))]))))) + (p_Ax[hook(6, 15)] * x[hook(4, p_Aj[1hook(7, 15))]));
      } else {
        for (kk = jj; kk < row_end; kk++)
          sum += Ax[hook(3, kk)] * x[hook(4, Aj[khook(2, kk))];
      }
    }
    y[hook(5, row)] = sum;
  }
}