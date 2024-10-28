//{"C_imag":9,"C_real":8,"cOffset":5,"data_imag":11,"data_real":10,"gSize":2,"grid_imag":7,"grid_real":6,"iu":0,"iv":1,"sSize":3,"support":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void grid(global const int* iu, global const int* iv, const int gSize, const int sSize, const int support, global const int* cOffset, global double* grid_real, global double* grid_imag, global const double* C_real, global const double* C_imag, global const double* data_real, global const double* data_imag) {
  int dind = get_global_id(0);
  int gind = iu[hook(0, dind)] + (gSize * iv[hook(1, dind)]) - support;
  int cind = cOffset[hook(5, dind)];

  for (int suppv = 0; suppv < sSize; suppv++) {
    for (int suppu = 0; suppu < sSize; suppu++) {
      grid_real[hook(6, gind + suppu)] = grid_real[hook(6, gind + suppu)] + (data_real[hook(10, dind)] * C_real[hook(8, cind + suppu)] - data_imag[hook(11, dind)] * C_imag[hook(9, cind + suppu)]);
      grid_imag[hook(7, gind + suppu)] = grid_imag[hook(7, gind + suppu)] + (data_real[hook(10, dind)] * C_imag[hook(9, cind + suppu)] + data_imag[hook(11, dind)] * C_real[hook(8, cind + suppu)]);
    }
    gind = gind + gSize;
    cind = cind + sSize;
  }
}