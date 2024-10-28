//{"dataArray":0,"shareArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getBufferAddress(global ulong* dataArray, local ulong* shareArray) {
  dataArray[hook(0, get_global_id(0))] = (ulong)(shareArray);
  dataArray[hook(0, get_global_id(0) + 1)] = (ulong)(shareArray + 1);
  dataArray[hook(0, get_global_id(0) + 2)] = (ulong)(dataArray);
  dataArray[hook(0, get_global_id(0) + 3)] = (ulong)(dataArray + 1);
}