//{"numPairs":1,"pairs":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clearOverlappingPairsKernel(global int4* pairs, int numPairs) {
  int pairId = get_global_id(0);
  if (pairId < numPairs) {
    pairs[hook(0, pairId)].z = 0xffffffff;
  }
}