//{"_numSecHash":11,"_queryProbes":12,"_reservoirSize":10,"aggNumReservoirs":5,"hashIndices":2,"numQueryEntries":6,"numReservoirsHashed":4,"queue":3,"sechash_a":8,"sechash_b":9,"segmentSizePow2":7,"tableMem":1,"tablePointers":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void extract_rows(global unsigned int* tablePointers, global unsigned int* tableMem, global unsigned int* hashIndices, global unsigned int* queue, unsigned int numReservoirsHashed, unsigned int aggNumReservoirs, unsigned int numQueryEntries, unsigned int segmentSizePow2, unsigned int sechash_a, unsigned int sechash_b, unsigned int _reservoirSize, unsigned int _numSecHash, unsigned int _queryProbes) {
  unsigned int queryIdx = get_global_id(0);
  unsigned int tb = get_global_id(1);
  unsigned int elemIdx = get_global_id(2);
  unsigned int hashIdx;
  unsigned int allocIdx;

  for (unsigned int k = 0; k < _queryProbes; k++) {
    hashIdx = hashIndices[hook(2, (unsigned int)(numQueryEntries * _queryProbes * tb + queryIdx * _queryProbes + k))];
    allocIdx = tablePointers[hook(0, (unsigned long long)(tb * numReservoirsHashed + hashIdx))];
    if (allocIdx != -1) {
      queue[hook(3, (unsigned int)(queryIdx * segmentSizePow2 + tb * _reservoirSize * _queryProbes + k * _reservoirSize + elemIdx))] = tableMem[hook(1, (unsigned long long)(tb * aggNumReservoirs * (_reservoirSize + 1) + allocIdx * (_reservoirSize + 1) + 1) + elemIdx)];
    }
  }
}