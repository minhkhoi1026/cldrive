//{"allprobsHash":0,"allprobsIdx":1,"hashes":2,"numInputEntries":3,"numProbes":6,"numTables":5,"rangePow":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_probes_storeid(global unsigned int* allprobsHash, global unsigned int* allprobsIdx, global unsigned int* hashes, unsigned int numInputEntries, unsigned int rangePow, unsigned int numTables, unsigned int numProbes) {
  unsigned int inputIdx = get_global_id(0);
  unsigned int tb = get_global_id(1);

  unsigned int hashIdx = 0;
  for (unsigned int k = 0; k < rangePow; k++) {
    hashIdx |= (unsigned)hashes[hook(2, (tb * (numInputEntries * rangePow) + inputIdx * rangePow + k))] << k;
  }
  allprobsHash[hook(0, (numInputEntries * numProbes * tb + inputIdx * numProbes + 0))] = hashIdx;
  allprobsIdx[hook(1, (numInputEntries * numProbes * tb + inputIdx * numProbes + 0))] = inputIdx;
  for (unsigned int k = 1; k < numProbes; k++) {
    allprobsHash[hook(0, (numInputEntries * numProbes * tb + inputIdx * numProbes + k))] = hashIdx ^ (1 << (k - 1));
    allprobsIdx[hook(1, (numInputEntries * numProbes * tb + inputIdx * numProbes + k))] = inputIdx;
  }
}