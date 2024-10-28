//{"N":0,"source":2,"target":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void per_element_add(const int N, global float* target, global const float* source) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  target[hook(1, globalId)] += source[hook(2, globalId)];
}