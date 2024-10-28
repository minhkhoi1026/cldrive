//{"a":0,"minData":1,"numOfTotal":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void minCl(global const int* a, global int* minData, const unsigned int numOfTotal) {
  for (size_t i = 0; i < numOfTotal; i++) {
    *minData = min(*minData, a[hook(0, i)]);
  }
}