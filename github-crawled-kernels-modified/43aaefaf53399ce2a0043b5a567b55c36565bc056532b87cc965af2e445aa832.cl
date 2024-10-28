//{"d_events":7,"d_times":8,"foundRecords":5,"maxInterval":2,"minInterval":1,"recordCount":6,"startOffset":4,"startRecords":3,"targetEvent":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void writeCandidates(unsigned char targetEvent, float minInterval, float maxInterval, global uint2* startRecords, global unsigned int* startOffset, global uint2* foundRecords, unsigned int recordCount, global unsigned char* d_events, global float* d_times) {
  unsigned int tid = get_local_size(0) * get_group_id(0) + get_local_id(0);
  uint2 ep;
  unsigned int myIdx, offset;
  float startTime, curTime;

  unsigned int listSize = 0;

  if (tid < recordCount) {
    ep = startRecords[hook(3, tid)];
    offset = startOffset[hook(4, tid)];
    myIdx = ep.x;

    curTime = startTime = d_times[hook(8, myIdx)];

    while (startTime - curTime < minInterval && myIdx > 0) {
      myIdx--;
      curTime = d_times[hook(8, myIdx)];
    }

    while (startTime - curTime <= maxInterval && myIdx > 0) {
      if (d_events[hook(7, myIdx)] == targetEvent) {
        foundRecords[hook(5, offset + listSize)].x = myIdx;
        foundRecords[hook(5, offset + listSize)].y = ep.y;
        listSize++;
      }
      myIdx--;
      curTime = d_times[hook(8, myIdx)];
    }
  }
}