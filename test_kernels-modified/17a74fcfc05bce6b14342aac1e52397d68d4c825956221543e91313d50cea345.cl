//{"N":0,"repeatSize":2,"source":4,"sourceSize":1,"target":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void repeated_add(const int N, const int sourceSize, const int repeatSize, global float* target, global const float* source) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  target[hook(3, globalId)] += source[hook(4, (globalId / repeatSize) % sourceSize)];
}