//{"N":0,"deviceFloat":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setFloatTest(int N, global float* deviceFloat) {
  int i = get_global_id(0);
  if (i < N) {
    deviceFloat[hook(1, i)] = 1.0 * i;
  }
}