//{"findMe":2,"globalLowerBound":3,"globalUpperBound":4,"outputArray":0,"sortedArray":1,"subdivSize":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarySearch(global uint4* outputArray, const global unsigned int* sortedArray, const unsigned int findMe, const unsigned int globalLowerBound, const unsigned int globalUpperBound, const unsigned int subdivSize) {
  unsigned int tid = get_global_id(0);

  unsigned int lowerBound = globalLowerBound + subdivSize * tid;
  unsigned int upperBound = lowerBound + subdivSize - 1;

  unsigned int lowerBoundElement = sortedArray[hook(1, lowerBound)];
  unsigned int upperBoundElement = sortedArray[hook(1, upperBound)];

  if ((lowerBoundElement > findMe) || (upperBoundElement < findMe)) {
    return;
  } else {
    outputArray[hook(0, 0)].x = lowerBound;
    outputArray[hook(0, 0)].y = upperBound;
    outputArray[hook(0, 0)].w = 1;
  }
}