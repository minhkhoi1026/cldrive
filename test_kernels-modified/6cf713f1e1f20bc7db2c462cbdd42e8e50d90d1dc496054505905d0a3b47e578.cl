//{"arrayLength":2,"inArray":0,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum_kernel(global double* inArray, global double* outArray, global int* arrayLength) {
  unsigned int gid = get_global_id(0);
  unsigned int numDim = get_work_dim();
  double prefixSum = 0;
  int count;
  for (int count = 0; count < gid; count++) {
    int value = gid;
    prefixSum += inArray[hook(0, count)];
  }
  outArray[hook(1, gid)] = prefixSum;
}