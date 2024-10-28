//{"N":0,"deviceInt":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setInt32Test(int N, global int* deviceInt) {
  int i = get_global_id(0);
  if (i < N) {
    deviceInt[hook(1, i)] = i;
  }
}