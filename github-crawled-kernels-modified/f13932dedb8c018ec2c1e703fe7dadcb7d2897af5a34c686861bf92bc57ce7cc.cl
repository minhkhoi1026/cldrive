//{"keySumArray":0,"ldsKeys":4,"ldsVals":5,"postSumArray":2,"preSumArray":1,"vecSize":3,"workPerThread":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void intraBlockInclusiveScanByKey(global unsigned int* keySumArray, global int* preSumArray, global int* postSumArray, const unsigned int vecSize, local unsigned int* ldsKeys, local int* ldsVals, const unsigned int workPerThread) {
  size_t groId = get_group_id(0);
  size_t gloId = get_global_id(0);
  size_t locId = get_local_id(0);
  size_t wgSize = get_local_size(0);
  unsigned int mapId = gloId * workPerThread;

  unsigned int offset;
  unsigned int key;
  int workSum;
  if (mapId < vecSize) {
    unsigned int prevKey;

    offset = 0;
    key = keySumArray[hook(0, mapId + offset)];
    workSum = preSumArray[hook(1, mapId + offset)];
    postSumArray[hook(2, mapId + offset)] = workSum;

    for (offset = offset + 1; offset < workPerThread; offset += 1) {
      prevKey = key;
      key = keySumArray[hook(0, mapId + offset)];
      if (mapId + offset < vecSize) {
        int y = preSumArray[hook(1, mapId + offset)];
        if (key == prevKey) {
          workSum = (workSum + y);
        } else {
          workSum = y;
        }
        postSumArray[hook(2, mapId + offset)] = workSum;
      }
    }
  }
  barrier(0x01);
  int scanSum = workSum;
  offset = 1;

  ldsVals[hook(5, locId)] = workSum;
  ldsKeys[hook(4, locId)] = key;

  for (offset = offset * 1; offset < wgSize; offset *= 2) {
    barrier(0x01);
    if (mapId < vecSize) {
      if (locId >= offset) {
        int y = ldsVals[hook(5, locId - offset)];
        unsigned int key1 = ldsKeys[hook(4, locId)];
        unsigned int key2 = ldsKeys[hook(4, locId - offset)];
        if (key1 == key2) {
          scanSum = (scanSum + y);
        } else
          scanSum = ldsVals[hook(5, locId)];
      }
    }
    barrier(0x01);
    ldsVals[hook(5, locId)] = scanSum;
  }
  barrier(0x01);

  for (offset = 0; offset < workPerThread; offset += 1) {
    barrier(0x02);

    if (mapId < vecSize && locId > 0) {
      int y = postSumArray[hook(2, mapId + offset)];
      unsigned int key1 = keySumArray[hook(0, mapId + offset)];
      unsigned int key2 = ldsKeys[hook(4, locId - 1)];
      if (key1 == key2) {
        int y2 = ldsVals[hook(5, locId - 1)];
        y = (y + y2);
      }
      postSumArray[hook(2, mapId + offset)] = y;
    }
  }
}