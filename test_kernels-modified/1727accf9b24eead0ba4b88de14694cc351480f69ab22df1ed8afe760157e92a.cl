//{"gridA":0,"gridB":1,"numElements":3,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotProduct1(global const float* gridA, global const float* gridB, global float* result, int const numElements) {
  int iGID = get_global_id(0);
  int totalThreads = get_global_size(0);
  int workPerThread = (numElements / totalThreads) + 1;

  int offset = 0;
  offset = iGID * workPerThread;

  result[hook(2, iGID)] = 0;
  for (int i = 0; i < workPerThread; ++i) {
    if (offset + i < numElements) {
      result[hook(2, iGID)] += (gridB[hook(1, offset + i)] * gridA[hook(0, offset + i)]);
    }
  }
}