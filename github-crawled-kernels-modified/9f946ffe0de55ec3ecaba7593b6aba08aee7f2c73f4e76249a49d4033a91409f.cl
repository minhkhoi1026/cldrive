//{"currArray":4,"dataArray":0,"interval":3,"num":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GeneratePattern(global ulong* dataArray, int num, int stride, int interval) {
  int idx = 0;
  global ulong* currArray = dataArray + get_global_id(0) * interval;
  for (int i = 0; i < num - 1; i++) {
    currArray[hook(4, idx)] = (ulong)(&currArray[hook(4, idx + stride)]);
    idx = idx + stride;
  }
  currArray[hook(4, idx)] = (ulong)currArray;
}