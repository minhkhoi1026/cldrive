//{"dataArray":0,"iter":1,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Process(global ulong2* dataArray, long iter, long offset) {
  global ulong2* currPtr = dataArray + get_global_id(0) * offset;
  while (iter-- > 0) {
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
    currPtr = (global ulong2*)((*currPtr).x);
  }
  dataArray[hook(0, get_global_id(0) * offset)] = (ulong)(currPtr);
}