//{"M":1,"N":0,"blockResults":4,"deviceInt":2,"localInt":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sumSqInt32Test(int N, int M, global int* deviceInt, local int* localInt, global int* blockResults) {
  int i = get_global_id(0);
  int j = get_local_id(0);

  localInt[hook(3, j)] = deviceInt[hook(2, i)] * deviceInt[hook(2, i)];
  barrier(0x01);

  if (j == 0) {
    int temp = 0;
    for (int k = 0; k < M; k++) {
      temp += localInt[hook(3, k)];
    }

    blockResults[hook(4, (i / M))] = temp;
  }
}