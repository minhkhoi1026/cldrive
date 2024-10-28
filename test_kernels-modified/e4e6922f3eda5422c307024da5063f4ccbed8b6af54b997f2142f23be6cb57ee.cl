//{"params_A":2,"params_B":3,"result":1,"rho":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hdrvdp_mtfCL(global double* rho, global double* result, global double* params_A, global double* params_B) {
  int pos = get_global_id(0);

  result[hook(1, pos)] = result[hook(1, pos)] + params_A[hook(2, 0)] * exp(-params_B[hook(3, 0)] * rho[hook(0, pos)]);
  result[hook(1, pos)] = result[hook(1, pos)] + params_A[hook(2, 1)] * exp(-params_B[hook(3, 1)] * rho[hook(0, pos)]);
  result[hook(1, pos)] = result[hook(1, pos)] + params_A[hook(2, 2)] * exp(-params_B[hook(3, 2)] * rho[hook(0, pos)]);
  result[hook(1, pos)] = result[hook(1, pos)] + params_A[hook(2, 3)] * exp(-params_B[hook(3, 3)] * rho[hook(0, pos)]);

  return;
}