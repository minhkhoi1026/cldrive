//{"dataArray":0,"interval":5,"iter":2,"localArray":1,"localPtr":6,"num":4,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Process(global ulong* dataArray, local ulong* localArray, long iter, int stride, int num, int interval) {
  if (get_local_id(0) % 64 == 0) {
    local ulong* localPtr = localArray + (get_local_id(0) / 64) * interval;
    int idx = 0;
    for (int i = 0; i < num - 1; i++) {
      localPtr[hook(6, idx)] = (ulong)(&localPtr[hook(6, idx + stride)]);
      idx = idx + stride;
    }
    localPtr[hook(6, idx)] = (ulong)localPtr;

    while (iter-- > 0) {
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
      localPtr = (local ulong*)(*localPtr);
    }
    dataArray[hook(0, get_global_id(0))] = (ulong)(localPtr);
  }
}