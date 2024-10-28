//{"findMe":2,"outputArray":0,"sortedArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarySearch(global uint4* outputArray, const global uint2* sortedArray, const unsigned int findMe) {
  unsigned int tid = get_global_id(0);

  uint2 element = sortedArray[hook(1, tid)];

  if ((element.x > findMe) || (element.y < findMe)) {
    return;
  } else {
    outputArray[hook(0, 0)].x = tid;
    outputArray[hook(0, 0)].w = 1;
  }
}