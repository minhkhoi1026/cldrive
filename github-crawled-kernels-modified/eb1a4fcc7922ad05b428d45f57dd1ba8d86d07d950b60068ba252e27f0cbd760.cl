//{"J_X":4,"J_Y":5,"d_E_X":1,"d_E_Y":2,"d_phi":0,"hx":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void D_electric_field(global double* d_phi, global double* d_E_X, global double* d_E_Y, double hx, int J_X, int J_Y) {
  int j = get_global_id(0) + 1;
  int k = get_global_id(1);
  if (j < (J_X - 1) && k < J_Y) {
    d_E_X[hook(1, j * J_Y + k)] = (d_phi[hook(0, (j - 1) * J_Y + k)] - d_phi[hook(0, (j + 1) * J_Y + k)]) / (2. * hx);
    d_E_Y[hook(2, j * J_Y + k)] = (d_phi[hook(0, j * J_Y + ((J_Y + k - 1) % J_Y))] - d_phi[hook(0, j * J_Y + ((k + 1) % J_Y))]) / (2. * hx);

    d_E_X[hook(1, k)] = 0.0;
    d_E_Y[hook(2, k)] = 0.0;
    d_E_X[hook(1, (J_X - 1) * J_Y + k)] = 0.0;
    d_E_Y[hook(2, (J_X - 1) * J_Y + k)] = 0.0;
  }
}