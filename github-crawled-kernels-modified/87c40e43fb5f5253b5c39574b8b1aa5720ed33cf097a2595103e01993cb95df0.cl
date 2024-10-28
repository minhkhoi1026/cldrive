//{"A":0,"B":1,"Mdim":3,"MdimPad":5,"Pdim":4,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pmax(global const float* A, global float* B, const float x, const int Mdim, const int Pdim, const int MdimPad) {
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  if ((globalRow <= Mdim) && (globalCol <= Pdim)) {
    B[hook(1, globalRow * MdimPad + globalCol)] = min(A[hook(0, globalRow * MdimPad + globalCol)], x);
  }
}