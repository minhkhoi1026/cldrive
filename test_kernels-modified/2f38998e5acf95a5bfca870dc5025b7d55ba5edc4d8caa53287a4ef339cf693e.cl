//{"AverageSignal":2,"coefsSignal":1,"inSignal":0,"levelsDone":6,"mLevels":7,"sharedArray":3,"signalLength":5,"tLevels":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwtHaar1D(global float* inSignal, global float* coefsSignal, global float* AverageSignal, local float* sharedArray, unsigned int tLevels, unsigned int signalLength, unsigned int levelsDone, unsigned int mLevels) {
  size_t localId = get_local_id(0);
  size_t groupId = get_group_id(0);
  size_t globalId = get_global_id(0);
  size_t localSize = get_local_size(0);

  sharedArray[hook(3, localId * 2)] = inSignal[hook(0, groupId * localSize * 2 + localId * 2)];
  sharedArray[hook(3, localId * 2 + 1)] = inSignal[hook(0, groupId * localSize * 2 + localId * 2 + 1)];

  if (0 == levelsDone) {
    sharedArray[hook(3, localId * 2)] /= sqrt((float)signalLength);
    sharedArray[hook(3, localId * 2 + 1)] /= sqrt((float)signalLength);
  }

  barrier(0x01);

  unsigned int levels = tLevels > mLevels ? mLevels : tLevels;
  unsigned int activeThreads = (1 << levels) / 2;
  unsigned int midOutPos = signalLength / 2;

  for (unsigned int i = 0; i < levels; ++i) {
    if (localId < activeThreads) {
      float data0 = sharedArray[hook(3, 2 * localId)];
      float data1 = sharedArray[hook(3, 2 * localId + 1)];

      sharedArray[hook(3, localId)] = (data0 + data1) / sqrt((float)2);
      unsigned int globalPos = midOutPos + groupId * activeThreads + localId;
      coefsSignal[hook(1, globalPos)] = (data0 - data1) / sqrt((float)2);

      midOutPos >>= 1;
    }
    activeThreads >>= 1;
    barrier(0x01);
  }

  if (0 == localId)
    AverageSignal[hook(2, groupId)] = sharedArray[hook(3, 0)];
}