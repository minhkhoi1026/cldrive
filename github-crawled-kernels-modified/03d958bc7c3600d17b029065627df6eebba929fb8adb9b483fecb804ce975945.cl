//{"deadSensor":0,"stop":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampleKernel(global const char* deadSensor, global int* stop) {
  int idx = get_global_id(0);

  if (deadSensor[hook(0, idx)] == 1)
    stop[hook(1, 0)] = 0;
}