//{"N":2,"inArray":0,"localBlock":3,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_Decomp(const global unsigned int* inArray, global unsigned int* outArray, unsigned int N, local unsigned int* localBlock) {
  unsigned int id = get_local_id(0);
  unsigned int group_id = get_group_id(0);

  localBlock[hook(3, id)] = inArray[hook(0, group_id * N * 2 + id)] + inArray[hook(0, group_id * N * 2 + N + id)];

  for (unsigned int stride = 1; stride < N; stride = stride * 2) {
    barrier(0x01);
    if (id * stride * 2 + stride < N) {
      int sum = localBlock[hook(3, id * stride * 2)] + localBlock[hook(3, id * stride * 2 + stride)];
      localBlock[hook(3, id * stride * 2)] = sum;
    }
  }

  if (id == 0) {
    outArray[hook(1, group_id)] = localBlock[hook(3, 0)];
  }
}