//{"d_csrColIndA":1,"d_csrRowPtrA":0,"d_csrRowPtrB":2,"d_csrRowPtrCt":3,"m":5,"s_csrRowPtrA":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_nnzCt(global const int* d_csrRowPtrA, global const int* d_csrColIndA, global const int* d_csrRowPtrB, global int* d_csrRowPtrCt, local int* s_csrRowPtrA, const int m) {
  int global_id = get_global_id(0);
  int start, stop, index, strideB, row_size_Ct = 0;

  if (global_id < m) {
    start = d_csrRowPtrA[hook(0, global_id)];
    stop = d_csrRowPtrA[hook(0, global_id + 1)];

    for (int i = start; i < stop; i++) {
      index = d_csrColIndA[hook(1, i)];
      strideB = d_csrRowPtrB[hook(2, index + 1)] - d_csrRowPtrB[hook(2, index)];
      row_size_Ct += strideB;
    }

    d_csrRowPtrCt[hook(3, global_id)] = row_size_Ct;
  }

  if (global_id == 0)
    d_csrRowPtrCt[hook(3, m)] = 0;
}