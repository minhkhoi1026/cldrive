//{"A":0,"B":1,"Mdim":2,"MdimPad":4,"Pdim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScalarElemDiv(global int* A, const int B, const int Mdim, const int Pdim, const int MdimPad) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  if ((globalRow <= Mdim) && (globalCol <= Pdim)) {
    A[hook(0, globalRow * MdimPad + globalCol)] = B / A[hook(0, globalRow * MdimPad + globalCol)];
  }
}