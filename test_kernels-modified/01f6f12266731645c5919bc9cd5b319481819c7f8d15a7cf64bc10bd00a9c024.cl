//{"N":0,"data":2,"multiplier":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiplyInplace(const int N, const float multiplier, global float* data) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  data[hook(2, globalId)] *= multiplier;
}