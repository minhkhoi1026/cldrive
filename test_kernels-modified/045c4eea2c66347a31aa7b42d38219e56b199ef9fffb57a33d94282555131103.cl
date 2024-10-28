//{"A":0,"B":1,"Mdim":3,"MdimPad":5,"globalCol":4,"indices":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_row_order(global const float* A, global float* B, global const int* indices, const int Mdim, const int globalCol, const int MdimPad) {
  const int globalRow = get_global_id(0);

  if ((globalRow <= Mdim)) {
    B[hook(1, globalRow)] = A[hook(0, indices[ghook(2, globalRow) * MdimPad + globalCol)];
  }
}