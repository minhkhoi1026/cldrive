//{"a":0,"maxData":2,"minData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(global const int* a, global int* minData, global int* maxData) {
  size_t i = get_global_id(0);

  *minData = min((int)*minData, a[hook(0, i)]);
  *maxData = min((int)*maxData, a[hook(0, i)]);
}