//{"I":2,"I_loc":5,"N":3,"N_loc":6,"eta":4,"eta_loc":7,"nLoc":0,"nTpt":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void p_se_kernel1(int nLoc, int nTpt, global int* I, global int* N, global double* eta, local int* I_loc, local int* N_loc, local double* eta_loc) {
  size_t globalId = get_global_id(0);
  size_t localId = get_local_id(0);
  size_t localSize = get_local_size(0);
  size_t totalSize = nLoc * nTpt;

  if (globalId < totalSize) {
    I_loc[hook(5, localId)] = I[hook(2, globalId)];
    N_loc[hook(6, localId)] = N[hook(3, globalId)];
    eta_loc[hook(7, localId)] = eta[hook(4, globalId)];

    eta_loc[hook(7, localId)] = (exp(eta_loc[hook(7, localId)]) * I_loc[hook(5, localId)]) / (N_loc[hook(6, localId)]);

    eta[hook(4, globalId)] = eta_loc[hook(7, localId)];
  } else {
    eta_loc[hook(7, localId)] = 0.0;
  }
}