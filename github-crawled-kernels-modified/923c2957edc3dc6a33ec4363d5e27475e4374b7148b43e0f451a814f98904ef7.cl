//{"Aj":2,"Arl":4,"Ax":3,"num_rows":5,"shared_ell_double":8,"stride":6,"threads":7,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void product_smell_dv_d(global double* x, global double* y, global unsigned long* Aj, global double* Ax, global unsigned long* Arl, unsigned long num_rows, unsigned long stride, unsigned long threads, local double* shared_ell_double) {
  unsigned int T = threads;
  unsigned int idx = get_global_id(0);
  unsigned int idb = get_local_id(0);
  unsigned int idp = idb % T;
  unsigned int row = idx / T;

  if (row >= num_rows) {
    return;
  }
  shared_ell_double[hook(8, idb)] = 0;
  double sum = 0;

  const unsigned long max = Arl[hook(4, row)];
  Ax += (row * T) + idp;
  Aj += (row * T) + idp;
  for (unsigned long k = 0; k < max; ++k) {
    sum += *Ax * x[hook(0, *Aj)];
    Ax += stride;
    Aj += stride;
  }
  shared_ell_double[hook(8, idb)] = sum;

  switch (threads) {
    case 32:
      if (idp < 16)
        shared_ell_double[hook(8, idb)] += shared_ell_double[hook(8, idb + 16)];
    case 16:
      if (idp < 8)
        shared_ell_double[hook(8, idb)] += shared_ell_double[hook(8, idb + 8)];
    case 8:
      if (idp < 4)
        shared_ell_double[hook(8, idb)] += shared_ell_double[hook(8, idb + 4)];
    case 4:
      if (idp < 2)
        shared_ell_double[hook(8, idb)] += shared_ell_double[hook(8, idb + 2)];
    case 2:
      if (idp == 0)
        y[hook(1, row)] = shared_ell_double[hook(8, idb)] + shared_ell_double[hook(8, idb + 1)];
      break;
    case 1:
      y[hook(1, row)] = shared_ell_double[hook(8, idb)];
      break;
    default:
      break;
  }
}