//{"N":0,"in":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(const int N, global const float* in, global float* out) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  out[hook(2, globalId)] = in[hook(1, globalId)];
}