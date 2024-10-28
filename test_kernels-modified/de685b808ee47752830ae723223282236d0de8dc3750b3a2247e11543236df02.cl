//{"nLoc":0,"nTpt":1,"offset":3,"p_se":4,"p_se_components":2,"p_se_components_loc":5,"p_se_loc":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void p_se_kernel2(int nLoc, int nTpt, global double* p_se_components, global double* offset, global double* p_se, local double* p_se_components_loc, local double* p_se_loc) {
  size_t globalId = get_global_id(0);
  size_t localId = get_local_id(0);
  size_t localSize = get_local_size(0);
  size_t totalSize = nLoc * nTpt;
  int offsetVal;

  if (globalId < totalSize) {
    p_se_components_loc[hook(5, localId)] = p_se_components[hook(2, globalId)];
    p_se_loc[hook(6, localId)] = p_se[hook(4, globalId)];
    offsetVal = offset[hook(3, globalId % nTpt)];
    p_se[hook(4, globalId)] = 1 - exp(-offsetVal * (p_se_components_loc[hook(5, localId)] + p_se_loc[hook(6, localId)]));
  }
}