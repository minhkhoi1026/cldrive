//{"dataArray":0,"interval":3,"iter":1,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Process(global ulong* dataArray, long iter, long offset, int interval) {
  global ulong* currPtr = dataArray + get_local_id(0) * interval;
  while (iter-- > 0) {
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
    currPtr = (global ulong*)(*currPtr);
  }
  dataArray[hook(0, get_local_id(0) * interval)] = (ulong)(currPtr);
}