//{"N":0,"data":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_inv(const int N, global float* data) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  data[hook(1, globalId)] = 1.0f / data[hook(1, globalId)];
}