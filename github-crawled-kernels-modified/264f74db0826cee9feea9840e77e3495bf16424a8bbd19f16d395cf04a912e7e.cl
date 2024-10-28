//{"currArray":3,"dataArray":0,"num":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GeneratePattern(global ulong2* dataArray, int num, int stride) {
  int idx = 0;
  global ulong2* currArray = dataArray + get_global_id(0) * stride * num;
  for (int i = 0; i < num - 1; i++) {
    currArray[hook(3, idx)].x = (ulong)(&currArray[hook(3, idx + stride)]);
    idx = idx + stride;
  }
  currArray[hook(3, idx)].x = (ulong)currArray;
}