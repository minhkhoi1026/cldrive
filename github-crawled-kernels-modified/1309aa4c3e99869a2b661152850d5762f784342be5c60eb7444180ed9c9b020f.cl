//{"currPtr_0":6,"currPtr_1":7,"currPtr_2":8,"currPtr_3":9,"dataArray":0,"interval":5,"iter":2,"localArray":1,"num":3,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Process_4(global ulong* dataArray, local ulong* localArray, long iter, int num, int stride, int interval) {
  int idx = 0;
  local ulong* currPtr_0 = localArray + 0 * interval + get_group_id(0) * num * stride;
  local ulong* currPtr_1 = localArray + 1 * interval + get_group_id(0) * num * stride;
  local ulong* currPtr_2 = localArray + 2 * interval + get_group_id(0) * num * stride;
  local ulong* currPtr_3 = localArray + 3 * interval + get_group_id(0) * num * stride;
  for (int i = 0; i < num - 1; i++) {
    currPtr_0[hook(6, idx)] = (ulong)(&currPtr_0[hook(6, idx + stride)]);
    currPtr_1[hook(7, idx)] = (ulong)(&currPtr_1[hook(7, idx + stride)]);
    currPtr_2[hook(8, idx)] = (ulong)(&currPtr_2[hook(8, idx + stride)]);
    currPtr_3[hook(9, idx)] = (ulong)(&currPtr_3[hook(9, idx + stride)]);
    idx = idx + stride;
  }
  currPtr_0[hook(6, idx)] = (ulong)currPtr_0;
  currPtr_1[hook(7, idx)] = (ulong)currPtr_1;
  currPtr_2[hook(8, idx)] = (ulong)currPtr_2;
  currPtr_3[hook(9, idx)] = (ulong)currPtr_3;

  while (iter-- > 0) {
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
    currPtr_0 = (local ulong*)(*currPtr_0);
    currPtr_1 = (local ulong*)(*currPtr_1);
    currPtr_2 = (local ulong*)(*currPtr_2);
    currPtr_3 = (local ulong*)(*currPtr_3);
  }
  dataArray[hook(0, 0)] = (ulong)(currPtr_0);
  dataArray[hook(0, 1)] = (ulong)(currPtr_1);
  dataArray[hook(0, 2)] = (ulong)(currPtr_2);
  dataArray[hook(0, 3)] = (ulong)(currPtr_3);
}