//{"a":0,"maxData":1,"numOfTotal":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxCl(global const int* a, global int* maxData, const unsigned int numOfTotal) {
  for (size_t i = 0; i < numOfTotal; i++) {
    *maxData = max(*maxData, a[hook(0, i)]);
  }
}