//{"N":0,"deviceDouble":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setDoubleTest(int N, global double* deviceDouble) {
  int i = get_global_id(0);
  if (i < N) {
    deviceDouble[hook(1, i)] = 1.0 * i;
  }
}