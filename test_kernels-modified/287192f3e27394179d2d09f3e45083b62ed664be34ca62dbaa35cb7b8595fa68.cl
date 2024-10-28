//{"N":2,"inArray":0,"localSum":3,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_DecompAtomics(const global unsigned int* inArray, global unsigned int* outArray, unsigned int N, local unsigned int* localSum) {
  unsigned int id = get_local_id(0);
  unsigned int group_id = get_group_id(0);

  unsigned int sum = inArray[hook(0, group_id * N * 2 + id)] + inArray[hook(0, group_id * N * 2 + N + id)];

  if (id == 0) {
    localSum[hook(3, 0)] = 0;
  }

  barrier(0x01);

  atomic_add(localSum, sum);

  barrier(0x01);

  if (id == 0) {
    outArray[hook(1, group_id)] = localSum[hook(3, 0)];
  }
}