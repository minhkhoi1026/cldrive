//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zeroFloatMemory(global float* buffer) {
  const int globalX = get_global_id(0);

  buffer[hook(0, globalX)] = 0.0f;
}