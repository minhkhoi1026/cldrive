//{"a":0,"diffData":3,"maxData":2,"minData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(global const int* a, global int* minData, global int* maxData, global int* diffData) {
  size_t i = get_global_id(0);

  atomic_min(minData, a[hook(0, i)]);
  atomic_max(maxData, a[hook(0, i)]);

  barrier(0x02);

  *diffData = *maxData - *minData;
}