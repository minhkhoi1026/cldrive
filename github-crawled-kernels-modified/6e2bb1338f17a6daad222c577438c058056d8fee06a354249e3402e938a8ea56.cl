//{"currPtr_0":4,"currPtr_1":5,"currPtr_2":6,"currPtr_3":7,"currPtr_4":8,"currPtr_5":9,"currPtr_6":10,"dataArray":0,"interval":3,"num":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GeneratePattern_7(global ulong* dataArray, int num, int stride, int interval) {
  int idx = 0;
  global ulong* currPtr_0 = dataArray + 0 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_1 = dataArray + 1 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_2 = dataArray + 2 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_3 = dataArray + 3 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_4 = dataArray + 4 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_5 = dataArray + 5 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_6 = dataArray + 6 * interval + get_group_id(0) * num * stride;
  for (int i = 0; i < num - 1; i++) {
    currPtr_0[hook(4, idx)] = (ulong)(&currPtr_0[hook(4, idx + stride)]);
    currPtr_1[hook(5, idx)] = (ulong)(&currPtr_1[hook(5, idx + stride)]);
    currPtr_2[hook(6, idx)] = (ulong)(&currPtr_2[hook(6, idx + stride)]);
    currPtr_3[hook(7, idx)] = (ulong)(&currPtr_3[hook(7, idx + stride)]);
    currPtr_4[hook(8, idx)] = (ulong)(&currPtr_4[hook(8, idx + stride)]);
    currPtr_5[hook(9, idx)] = (ulong)(&currPtr_5[hook(9, idx + stride)]);
    currPtr_6[hook(10, idx)] = (ulong)(&currPtr_6[hook(10, idx + stride)]);
    idx = idx + stride;
  }
  currPtr_0[hook(4, idx)] = (ulong)currPtr_0;
  currPtr_1[hook(5, idx)] = (ulong)currPtr_1;
  currPtr_2[hook(6, idx)] = (ulong)currPtr_2;
  currPtr_3[hook(7, idx)] = (ulong)currPtr_3;
  currPtr_4[hook(8, idx)] = (ulong)currPtr_4;
  currPtr_5[hook(9, idx)] = (ulong)currPtr_5;
  currPtr_6[hook(10, idx)] = (ulong)currPtr_6;
}