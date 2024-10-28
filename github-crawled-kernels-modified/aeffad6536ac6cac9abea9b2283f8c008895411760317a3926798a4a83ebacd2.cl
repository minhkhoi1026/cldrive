//{"currPtr_0":4,"currPtr_1":5,"currPtr_10":14,"currPtr_11":15,"currPtr_12":16,"currPtr_13":17,"currPtr_14":18,"currPtr_2":6,"currPtr_3":7,"currPtr_4":8,"currPtr_5":9,"currPtr_6":10,"currPtr_7":11,"currPtr_8":12,"currPtr_9":13,"dataArray":0,"interval":3,"num":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GeneratePattern_15(global ulong* dataArray, int num, int stride, int interval) {
  int idx = 0;
  global ulong* currPtr_0 = dataArray + 0 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_1 = dataArray + 1 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_2 = dataArray + 2 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_3 = dataArray + 3 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_4 = dataArray + 4 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_5 = dataArray + 5 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_6 = dataArray + 6 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_7 = dataArray + 7 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_8 = dataArray + 8 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_9 = dataArray + 9 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_10 = dataArray + 10 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_11 = dataArray + 11 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_12 = dataArray + 12 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_13 = dataArray + 13 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_14 = dataArray + 14 * interval + get_group_id(0) * num * stride;
  for (int i = 0; i < num - 1; i++) {
    currPtr_0[hook(4, idx)] = (ulong)(&currPtr_0[hook(4, idx + stride)]);
    currPtr_1[hook(5, idx)] = (ulong)(&currPtr_1[hook(5, idx + stride)]);
    currPtr_2[hook(6, idx)] = (ulong)(&currPtr_2[hook(6, idx + stride)]);
    currPtr_3[hook(7, idx)] = (ulong)(&currPtr_3[hook(7, idx + stride)]);
    currPtr_4[hook(8, idx)] = (ulong)(&currPtr_4[hook(8, idx + stride)]);
    currPtr_5[hook(9, idx)] = (ulong)(&currPtr_5[hook(9, idx + stride)]);
    currPtr_6[hook(10, idx)] = (ulong)(&currPtr_6[hook(10, idx + stride)]);
    currPtr_7[hook(11, idx)] = (ulong)(&currPtr_7[hook(11, idx + stride)]);
    currPtr_8[hook(12, idx)] = (ulong)(&currPtr_8[hook(12, idx + stride)]);
    currPtr_9[hook(13, idx)] = (ulong)(&currPtr_9[hook(13, idx + stride)]);
    currPtr_10[hook(14, idx)] = (ulong)(&currPtr_10[hook(14, idx + stride)]);
    currPtr_11[hook(15, idx)] = (ulong)(&currPtr_11[hook(15, idx + stride)]);
    currPtr_12[hook(16, idx)] = (ulong)(&currPtr_12[hook(16, idx + stride)]);
    currPtr_13[hook(17, idx)] = (ulong)(&currPtr_13[hook(17, idx + stride)]);
    currPtr_14[hook(18, idx)] = (ulong)(&currPtr_14[hook(18, idx + stride)]);
    idx = idx + stride;
  }
  currPtr_0[hook(4, idx)] = (ulong)currPtr_0;
  currPtr_1[hook(5, idx)] = (ulong)currPtr_1;
  currPtr_2[hook(6, idx)] = (ulong)currPtr_2;
  currPtr_3[hook(7, idx)] = (ulong)currPtr_3;
  currPtr_4[hook(8, idx)] = (ulong)currPtr_4;
  currPtr_5[hook(9, idx)] = (ulong)currPtr_5;
  currPtr_6[hook(10, idx)] = (ulong)currPtr_6;
  currPtr_7[hook(11, idx)] = (ulong)currPtr_7;
  currPtr_8[hook(12, idx)] = (ulong)currPtr_8;
  currPtr_9[hook(13, idx)] = (ulong)currPtr_9;
  currPtr_10[hook(14, idx)] = (ulong)currPtr_10;
  currPtr_11[hook(15, idx)] = (ulong)currPtr_11;
  currPtr_12[hook(16, idx)] = (ulong)currPtr_12;
  currPtr_13[hook(17, idx)] = (ulong)currPtr_13;
  currPtr_14[hook(18, idx)] = (ulong)currPtr_14;
}