//{"dataArray":0,"interval":4,"iter":1,"num":2,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Process_3(global ulong* dataArray, long iter, int num, int stride, int interval) {
  global ulong* currPtr_0 = dataArray + 0 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_1 = dataArray + 1 * interval + get_group_id(0) * num * stride;
  global ulong* currPtr_2 = dataArray + 2 * interval + get_group_id(0) * num * stride;
  while (iter-- > 0) {
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
    currPtr_0 = (global ulong*)(*currPtr_0);
    currPtr_1 = (global ulong*)(*currPtr_1);
    currPtr_2 = (global ulong*)(*currPtr_2);
  }
  dataArray[hook(0, 0 * interval)] = (ulong)(currPtr_0);
  dataArray[hook(0, 1 * interval)] = (ulong)(currPtr_1);
  dataArray[hook(0, 2 * interval)] = (ulong)(currPtr_2);
}