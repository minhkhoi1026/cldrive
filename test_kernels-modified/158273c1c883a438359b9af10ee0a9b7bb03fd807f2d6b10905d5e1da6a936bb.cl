//{"d_events":6,"d_times":7,"foundRecordsCount":4,"maxInterval":2,"minInterval":1,"recordCount":5,"startRecords":3,"targetEvent":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void countCandidates(unsigned char targetEvent, float minInterval, float maxInterval, global uint2* startRecords, global unsigned int* foundRecordsCount, unsigned int recordCount, global unsigned char* d_events, global float* d_times) {
  unsigned int tid = get_local_size(0) * get_group_id(0) + get_local_id(0);
  uint2 ep;
  unsigned int myIdx;
  float startTime, curTime;

  unsigned int listSize = 0;

  if (tid < recordCount) {
    ep = startRecords[hook(3, tid)];
    myIdx = ep.x;

    curTime = startTime = d_times[hook(7, myIdx)];

    while (startTime - curTime < minInterval && myIdx > 0) {
      myIdx--;
      curTime = d_times[hook(7, myIdx)];
    }

    while (startTime - curTime <= maxInterval && myIdx > 0) {
      if (d_events[hook(6, myIdx)] == targetEvent) {
        listSize++;
      }
      myIdx--;
      curTime = d_times[hook(7, myIdx)];
    }
    foundRecordsCount[hook(4, tid)] = listSize;
  }
}