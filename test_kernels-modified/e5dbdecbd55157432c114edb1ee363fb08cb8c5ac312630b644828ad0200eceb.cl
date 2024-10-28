//{"arrayLength":2,"inArray":0,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum_kernel(global float* inArray, global float* outArray, global int* arrayLength) {
  unsigned int gid = get_global_id(0);
  float prefixSum = 0.0;
  int count;
  for (int count = 0; count < gid; count++) {
    int value = gid;
    prefixSum += inArray[hook(0, count)];
  }
  outArray[hook(1, gid)] = prefixSum;
}