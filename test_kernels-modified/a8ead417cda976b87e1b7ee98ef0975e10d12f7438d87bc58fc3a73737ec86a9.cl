//{"M":1,"N":0,"blockResults":4,"deviceDouble":2,"localDouble":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sumSqDoubleTest(int N, int M, global double* deviceDouble, local double* localDouble, global double* blockResults) {
  int i = get_global_id(0);
  int j = get_local_id(0);

  localDouble[hook(3, j)] = deviceDouble[hook(2, i)] * deviceDouble[hook(2, i)];
  barrier(0x01);

  if (j == 0) {
    double temp = 0;
    for (int k = 0; k < M; k++) {
      temp += localDouble[hook(3, k)];
    }

    blockResults[hook(4, (i / M))] = temp;
  }
}