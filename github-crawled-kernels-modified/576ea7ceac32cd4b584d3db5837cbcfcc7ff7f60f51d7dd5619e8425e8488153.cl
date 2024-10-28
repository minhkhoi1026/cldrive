//{"_numSecHash":10,"_reservoirSize":9,"aggNumReservoirs":5,"idBase":6,"numProbePerTb":3,"numReservoirsHashed":4,"sechash_a":7,"sechash_b":8,"storelog":2,"tableMem":1,"tablePointers":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_table(global unsigned int* tablePointers, global unsigned int* tableMem, global unsigned int* storelog, unsigned int numProbePerTb, unsigned int numReservoirsHashed, unsigned int aggNumReservoirs, unsigned int idBase, unsigned int sechash_a, unsigned int sechash_b, unsigned int _reservoirSize, unsigned int _numSecHash) {
  unsigned int tb = get_global_id(0);
  unsigned int probeIdx = get_global_id(1);
  unsigned int id = storelog[hook(2, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx))];
  unsigned int hashIdx = storelog[hook(2, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 3))];
  unsigned int allocIdx = tablePointers[hook(0, max((unsigned int)0, (unsigned int)(unsigned long long)(tb * numReservoirsHashed + hashIdx)))];

  unsigned int locCapped = storelog[hook(2, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 2))];

  if (locCapped < _reservoirSize) {
    tableMem[hook(1, (unsigned long long)(tb * aggNumReservoirs * (_reservoirSize + 1) + allocIdx * (_reservoirSize + 1) + 1) + locCapped)] = id + idBase;
  }
}