//{"N":0,"in":2,"multiplier":1,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiplyConstant(const int N, const float multiplier, global const float* in, global float* out) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  out[hook(3, globalId)] = multiplier * in[hook(2, globalId)];
}