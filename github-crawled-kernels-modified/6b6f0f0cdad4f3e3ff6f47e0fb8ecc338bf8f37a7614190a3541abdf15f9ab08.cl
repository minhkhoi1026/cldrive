//{"LMatrix":0,"inplaceMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelLUCombine(global double* LMatrix, global double* inplaceMatrix) {
  int i = get_global_id(1);
  int j = get_global_id(0);
  int gidx = get_group_id(0);
  int gidy = get_group_id(1);
  int dimension = get_global_size(0);
  if (i > j) {
    int dimension = get_global_size(0);
    inplaceMatrix[hook(1, i * dimension + j)] = LMatrix[hook(0, i * dimension + j)];
  }
}