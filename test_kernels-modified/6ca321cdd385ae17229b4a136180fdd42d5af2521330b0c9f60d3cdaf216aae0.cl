//{"buffer":0,"dummyBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void aligned_sequential(global float* buffer, global float* dummyBuffer) {
  *dummyBuffer = buffer[hook(0, get_local_id(0))];
}