//{"d_Mat":0,"d_Vect":1,"numRows":4,"result_vec":2,"vecLen":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixvectorMult(global float* d_Mat, global float* d_Vect, global float* result_vec, global int* vecLen, global int* numRows) {
  int threadGid = get_global_id(0);
  int numThread = get_global_size(0);
  float tempResult = 0;
  if (threadGid < (*numRows)) {
    for (int colCount = 0; colCount < (*vecLen); colCount++) {
      tempResult = tempResult + d_Vect[hook(1, colCount)] * d_Mat[hook(0, threadGid * (*vecLen) + colCount)];
    }
    result_vec[hook(2, threadGid)] = tempResult;
  }
}