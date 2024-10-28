//{"dataArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getBufferAddress2(global ulong* dataArray) {
  dataArray[hook(0, get_global_id(0) + 2)] = dataArray[hook(0, get_global_id(0))];
  dataArray[hook(0, get_global_id(0) + 3)] = dataArray[hook(0, get_global_id(0) + 1)];
}