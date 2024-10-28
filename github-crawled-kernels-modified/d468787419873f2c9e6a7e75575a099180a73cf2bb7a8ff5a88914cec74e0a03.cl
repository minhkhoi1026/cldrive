//{"_numSecHash":14,"_reservoirSize":13,"aggNumReservoirs":9,"allprobsHash":3,"allprobsIdx":4,"numProbePerTb":8,"numRands":10,"numReservoirsHashed":7,"reservoirRand":6,"sechash_a":11,"sechash_b":12,"storelog":5,"tableMem":0,"tableMemAllocator":2,"tablePointers":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reservoir_sampling_recur(global unsigned int* tableMem, global unsigned int* tablePointers, global unsigned int* tableMemAllocator, global unsigned int* allprobsHash, global unsigned int* allprobsIdx, global unsigned int* storelog, global unsigned int* reservoirRand, unsigned int numReservoirsHashed, unsigned int numProbePerTb, unsigned int aggNumReservoirs, unsigned int numRands, unsigned int sechash_a, unsigned int sechash_b, unsigned int _reservoirSize, unsigned int _numSecHash) {
  unsigned int probeIdx = get_global_id(0);
  unsigned int tb = get_global_id(1);

  int TB = numProbePerTb * tb;

  unsigned int hashIdx = allprobsHash[hook(3, (unsigned int)(numProbePerTb * tb + probeIdx))];
  unsigned int inputIdx = allprobsIdx[hook(4, (unsigned int)(numProbePerTb * tb + probeIdx))];
  unsigned int ct = 0;

  unsigned int allocIdx = atomic_cmpxchg(tablePointers + (unsigned long long)(tb * numReservoirsHashed + hashIdx), -1, 0);
  if (allocIdx != -1) {
    unsigned int counter = atom_inc(tableMem + (unsigned long long)(tb * aggNumReservoirs * (_reservoirSize + 1) + allocIdx * (_reservoirSize + 1)));

    unsigned int reservoir_full = (counter + 1) > _reservoirSize;

    unsigned int reservoirRandNum = reservoirRand[hook(6, min(numRands, counter))];

    unsigned int location = reservoir_full * (reservoirRandNum) + (1 - reservoir_full) * counter;

    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx))] = inputIdx;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 1))] = counter;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 2))] = location;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 3))] = hashIdx;

  } else {
    allocIdx = atom_inc(tableMemAllocator + (unsigned)(tb));
    tablePointers[hook(1, (unsigned long long)(tb * numReservoirsHashed + hashIdx))] = allocIdx;

    unsigned int counter = atom_inc(tableMem + (unsigned long long)(tb * aggNumReservoirs * (_reservoirSize + 1) + allocIdx * (_reservoirSize + 1)));

    unsigned int reservoir_full = (counter + 1) > _reservoirSize;

    unsigned int reservoirRandNum = reservoirRand[hook(6, min(numRands, counter))];

    unsigned int location = reservoir_full * (reservoirRandNum) + (1 - reservoir_full) * counter;

    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx))] = inputIdx;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 1))] = counter;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 2))] = location;
    storelog[hook(5, (unsigned int)(numProbePerTb * tb * 4 + 4 * probeIdx + 3))] = hashIdx;
  }
}