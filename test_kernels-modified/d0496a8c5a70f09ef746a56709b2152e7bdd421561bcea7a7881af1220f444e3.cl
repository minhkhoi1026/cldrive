//{"input":0,"inputSize":2,"output":1,"reductionSums":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inefficient(global const int* input, global int* output, const int inputSize, local int* reductionSums) {
  const int globalID = get_global_id(0);
  const int localID = get_local_id(0);
  const int localSize = get_local_size(0);
  const int workgroupID = globalID / localSize;

  reductionSums[hook(3, localID)] = input[hook(0, globalID)];

  barrier(0x01);
  if (localID == 0) {
    int sum = 0;
    for (int i = 0; i < localSize; i++) {
      if ((i + localID) < localSize) {
        sum += reductionSums[hook(3, i + localID)];
      }
    }
    output[hook(1, workgroupID)] = sum;
  }
}