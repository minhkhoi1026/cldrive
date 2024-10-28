//{"dataArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getBufferAddress(global ulong* dataArray) {
  dataArray[hook(0, get_global_id(0))] = (ulong)(dataArray);
  dataArray[hook(0, get_global_id(0) + 1)] = (ulong)(dataArray + 1);
}