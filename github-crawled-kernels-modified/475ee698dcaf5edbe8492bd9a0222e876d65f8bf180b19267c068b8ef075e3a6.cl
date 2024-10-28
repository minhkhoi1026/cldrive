//{"inputbuffer":0,"outputbuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void debugKernel(global float* inputbuffer, global float* outputbuffer) {
  unsigned int globalID = get_global_id(0);
  unsigned int value = 0;
  value = inputbuffer[hook(0, globalID)];
  outputbuffer[hook(1, globalID)] = value;
}