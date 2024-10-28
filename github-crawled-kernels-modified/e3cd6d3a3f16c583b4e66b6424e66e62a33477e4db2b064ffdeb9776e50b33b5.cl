//{"As":3,"Bs":4,"d_MatA":1,"d_MatB":2,"d_cols":6,"d_rows":5,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matMatMultKernelDP(global double* output, global double* d_MatA, global double* d_MatB, local double* As, local double* Bs, global int* d_rows, global int* d_cols) {
  int aBegin;
  int a;
  int b;
  int k;
  int c;
  double Csub = 0.0f;
  int bx = get_group_id(0);
  int by = get_group_id(1);
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  aBegin = ((*d_rows) * 16 * by);
  int aEnd = aBegin + (*d_rows) - 1;
  int aStep = 16;
  int bBegin = 16 * bx;
  int bStep = 16 * (*d_rows);
  for (a = aBegin, b = bBegin; a <= aEnd; a += aStep, b += bStep) {
    As[hook(3, tx + ty * 16)] = d_MatA[hook(1, a + (*d_rows) * ty + tx)];
    Bs[hook(4, tx + ty * 16)] = d_MatB[hook(2, b + (*d_cols) * ty + tx)];
    barrier(0x01);
    for (k = 0; k < 16; ++k)
      Csub += As[hook(3, k + ty * 16)] * Bs[hook(4, tx + k * 16)];
    barrier(0x01);
  }
  output[hook(0, get_global_id(1) * get_global_size(0) + get_global_id(0))] = Csub;
}