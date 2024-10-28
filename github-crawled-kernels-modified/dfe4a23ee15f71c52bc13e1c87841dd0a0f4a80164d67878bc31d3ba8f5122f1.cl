//{"infiNorm":2,"input":0,"rowCol":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void infinityNorm_kernel(global double* input, global int* rowCol, global double* infiNorm) {
  int threadGid = get_global_id(0);
  double sum;
  if (threadGid < rowCol[hook(1, 0)]) {
    sum = 0;
    for (int colCount = 0; colCount < rowCol[hook(1, 1)]; colCount++) {
      sum = sum + (input[hook(0, threadGid * rowCol[1hook(1, 1) + colCount)]);
    }
    input[hook(0, threadGid * rowCol[1hook(1, 1))] = sum;
  }
  barrier(0x01);
  if (threadGid == 0) {
    sum = 0;
    for (int rowCount = 0; rowCount < rowCol[hook(1, 0)]; rowCount++) {
      sum = (sum > input[hook(0, rowCount * rowCol[1hook(1, 1))] ? sum : input[hook(0, rowCount * rowCol[1hook(1, 1))]);
    }
    *infiNorm = sum;
  }
}