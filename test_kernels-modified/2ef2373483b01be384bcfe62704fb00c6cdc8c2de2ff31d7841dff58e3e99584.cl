//{"pdata":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_work_group_size(1000))) kernel void softmax(global float* pdata) {
  const int x = get_global_id(0);
  pdata[hook(0, x)] = exp(pdata[hook(0, x)]);
}