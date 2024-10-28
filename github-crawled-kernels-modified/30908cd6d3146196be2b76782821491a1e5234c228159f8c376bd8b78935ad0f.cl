//{"d_Mat":0,"d_scalar":1,"numCols":3,"numRows":4,"result_mat":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scalarMatrixMultDP(global double* d_Mat, global int* d_scalar, global double* result_mat, global int* numCols, global int* numRows) {
  int threadGid = get_global_id(0);
  int numThread = get_global_size(0);
  int colCount;
  if (threadGid < (numThread)) {
    for (colCount = 0; colCount < (*numCols); colCount++) {
      result_mat[hook(2, threadGid * (*numCols) + colCount)] = d_Mat[hook(0, threadGid * (*numCols) + colCount)] * (*d_scalar);
    }
  }
}