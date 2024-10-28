//{"M":1,"N":0,"blockResults":4,"deviceFloat":2,"localFloat":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sumSqFloatTest(int N, int M, global float* deviceFloat, local float* localFloat, global float* blockResults) {
  int i = get_global_id(0);
  int j = get_local_id(0);

  localFloat[hook(3, j)] = deviceFloat[hook(2, i)] * deviceFloat[hook(2, i)];
  barrier(0x01);

  if (j == 0) {
    float temp = 0;
    for (int k = 0; k < M; k++) {
      temp += localFloat[hook(3, k)];
    }

    blockResults[hook(4, (i / M))] = temp;
  }
}