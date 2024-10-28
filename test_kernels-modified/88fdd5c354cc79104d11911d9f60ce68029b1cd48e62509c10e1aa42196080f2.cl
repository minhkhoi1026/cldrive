//{"data":1,"totalElements":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(int totalElements, global float* data) {
  int offset = 0;
  int linearId = get_global_id(0);
  if (linearId >= totalElements) {
    return;
  }
  data[hook(1, linearId)] = data[hook(1, linearId)] + 1;
}