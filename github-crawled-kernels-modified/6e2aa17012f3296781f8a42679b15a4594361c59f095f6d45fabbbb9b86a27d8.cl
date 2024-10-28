//{"a":0,"minData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void minCl(global const int* a, global int* minData) {
  size_t i = get_global_id(0);

  *minData = min((int)minData, a[hook(0, i)]);
}