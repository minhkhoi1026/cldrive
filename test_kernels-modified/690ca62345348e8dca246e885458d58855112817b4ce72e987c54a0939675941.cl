//{"input":1,"inputSize":2,"keys":0,"numSubdivisions":3,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarySearch_mulkeysConcurrent(global unsigned int* keys, global unsigned int* input, const unsigned int inputSize, const unsigned int numSubdivisions, global int* output) {
  int lBound = (get_global_id(0) % numSubdivisions) * (inputSize / numSubdivisions);
  int uBound = lBound + inputSize / numSubdivisions;
  int myKey = keys[hook(0, get_global_id(0) / numSubdivisions)];
  int mid;
  while (uBound >= lBound) {
    mid = (lBound + uBound) / 2;
    if (input[hook(1, mid)] == myKey) {
      output[hook(4, get_global_id(0) / numSubdivisions)] = mid;
      return;
    } else if (input[hook(1, mid)] > myKey)
      uBound = mid - 1;
    else
      lBound = mid + 1;
  }
}