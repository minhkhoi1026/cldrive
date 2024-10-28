//{"J_X":3,"J_Y":4,"d_E_X":0,"d_E_Y":1,"hx":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void D_electric_field_border(global double* d_E_X, global double* d_E_Y, double hx, int J_X, int J_Y) {
  int k = get_global_id(0);
  if (k < J_Y) {
    d_E_X[hook(0, k)] = 0.0;
    d_E_Y[hook(1, k)] = 0.0;
    d_E_X[hook(0, (J_X - 1) * J_Y + k)] = 0.0;
    d_E_Y[hook(1, (J_X - 1) * J_Y + k)] = 0.0;
  }
}