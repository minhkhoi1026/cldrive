//{"blockSumsBuffer":1,"inOutBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void indexing_sum_tester3(global unsigned int* inOutBuffer, global unsigned int* blockSumsBuffer) {
  inOutBuffer[hook(0, get_global_id(0))] += blockSumsBuffer[hook(1, get_group_id(0))];
}