//{"currPtr_0":4,"dataArray":0,"interval":3,"num":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GeneratePattern_1(global ulong* dataArray, int num, int stride, int interval) {
  int idx = 0;
  global ulong* currPtr_0 = dataArray + 0 * interval + get_group_id(0) * num * stride;
  for (int i = 0; i < num - 1; i++) {
    currPtr_0[hook(4, idx)] = (ulong)(&currPtr_0[hook(4, idx + stride)]);
    idx = idx + stride;
  }
  currPtr_0[hook(4, idx)] = (ulong)currPtr_0;
}