//{"binhash_a":6,"binhash_b":7,"dataIdx":1,"dataMarker":3,"dataVal":2,"groupHashingSize":11,"hash_a":4,"hash_b":5,"hashes":0,"hashesLocal":12,"numInputEntries":8,"rangePow":9,"samFactor":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sparse_rand_proj(global unsigned int* hashes, global const unsigned int* dataIdx, global const float* dataVal, global const unsigned int* dataMarker, global const unsigned int* hash_a, global const unsigned int* hash_b, global const unsigned int* binhash_a, global const unsigned int* binhash_b, unsigned int numInputEntries, unsigned int rangePow, unsigned int samFactor, unsigned int groupHashingSize, local unsigned int* hashesLocal) {
  unsigned int g_inputBatchIdx = get_global_id(1);
  unsigned int g_tb = get_global_id(2);
  unsigned int numTables = get_global_size(2);
  unsigned int l_hashIdx = get_local_id(0);

  float value = 0;
  unsigned int ok = 0;
  unsigned int indice = 0;
  unsigned int inputIdx;
  unsigned int sparseLen;
  unsigned int start = 0;

  unsigned int a1 = hash_a[hook(4, g_tb * rangePow + l_hashIdx)];
  unsigned int b1 = hash_b[hook(5, g_tb * rangePow + l_hashIdx)];
  unsigned int a2 = binhash_a[hook(6, g_tb * rangePow + l_hashIdx)];
  unsigned int b2 = binhash_b[hook(7, g_tb * rangePow + l_hashIdx)];

  for (unsigned int i = 0; i < groupHashingSize; i++) {
    inputIdx = g_inputBatchIdx * groupHashingSize + i;
    value = 0;

    start = dataMarker[hook(3, inputIdx)];
    sparseLen = dataMarker[hook(3, inputIdx + 1)] - start;

    for (unsigned int k = 0; k < sparseLen; k++) {
      indice = dataIdx[hook(1, start + k)];
      ok = ((unsigned)(a2 * indice + b2) >> 31);
      value += (((unsigned)(a1 * indice + b1) >> (32 - samFactor)) == 1) ? (ok ? dataVal[hook(2, start + indice)] : (-dataVal[hook(2, start + indice)])) : 0;
    }
    hashesLocal[hook(12, i * rangePow + l_hashIdx)] = value > 0;
  }

  event_t copyback = async_work_group_copy(hashes + g_tb * (numInputEntries * rangePow) + g_inputBatchIdx * groupHashingSize * rangePow, hashesLocal, groupHashingSize * rangePow, 0);

  wait_group_events(1, &copyback);
}