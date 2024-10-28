//{"X":1,"dimension":6,"groupHashingSize":8,"hashes":0,"hashesLocal":11,"indices":3,"indicesLocal":9,"numInputEntries":4,"randBits":2,"randBitsLocal":10,"rangePow":7,"samSize":5,"waits":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dense_rand_proj(global unsigned int* hashes, global const float* X, global const short* randBits, global const unsigned int* indices, unsigned int numInputEntries, unsigned int samSize, unsigned int dimension, unsigned int rangePow, unsigned int groupHashingSize, local unsigned int* indicesLocal, local short* randBitsLocal, local unsigned int* hashesLocal) {
  unsigned int g_inputBatchIdx = get_global_id(1);
  unsigned int g_tb = get_global_id(2);
  unsigned int numTables = get_global_size(2);
  unsigned int l_hashIdx = get_local_id(0);

  event_t waits[3];
  waits[hook(12, 0)] = async_work_group_copy(indicesLocal, indices + g_tb * rangePow * samSize, samSize * rangePow, 0);

  waits[hook(12, 1)] = async_work_group_copy(randBitsLocal, randBits + g_tb * rangePow * samSize, samSize * rangePow, 0);

  wait_group_events(2, waits);

  float value = 0;
  unsigned int ok = 0;
  unsigned int indice = 0;
  float elem;
  unsigned int inputIdx;

  for (unsigned int i = 0; i < groupHashingSize; i++) {
    inputIdx = g_inputBatchIdx * groupHashingSize + i;
    value = 0;

    for (unsigned int k = 0; k < samSize; k++) {
      indice = indicesLocal[hook(9, l_hashIdx * samSize + k)];
      ok = randBitsLocal[hook(10, l_hashIdx * samSize + k)] >= 0;
      elem = X[hook(1, inputIdx * dimension + indice)];
      value += ok ? elem : (-elem);
    }

    hashesLocal[hook(11, i * rangePow + l_hashIdx)] = value > 0;
  }

  event_t copyback = async_work_group_copy(hashes + g_tb * (numInputEntries * rangePow) + g_inputBatchIdx * groupHashingSize * rangePow, hashesLocal, groupHashingSize * rangePow, 0);

  wait_group_events(1, &copyback);
}