//{"buffer_size":5,"isTerminalStateRecord":1,"lastRelevantIndex":4,"nextRecordIndex":3,"recordStart":2,"rewardRecord":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rewards(global float* rewardRecord, global const char* isTerminalStateRecord, global const int* recordStart, global const int* nextRecordIndex, global int* lastRelevantIndex, unsigned int buffer_size) {
  if (get_global_id(0) == 0) {
    *lastRelevantIndex = -1;
    int i = *nextRecordIndex - 1;
    do {
      if (i < 0)
        i = buffer_size - 1;

      if (*lastRelevantIndex == -1 && isTerminalStateRecord[hook(1, i)])
        *lastRelevantIndex = i;
      if (*lastRelevantIndex != -1) {
        if (!isTerminalStateRecord[hook(1, i)])
          rewardRecord[hook(0, i)] = rewardRecord[hook(0, (i + 1) % buffer_size)] * 0.99f;
      }
      i--;
    } while (i != *recordStart - 1);
  }
}