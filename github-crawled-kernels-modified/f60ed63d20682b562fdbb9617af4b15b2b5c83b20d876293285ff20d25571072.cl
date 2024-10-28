//{"buffer1":0,"buffer2":1,"numElements":3,"outputBuffer":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global int* buffer1, global int* buffer2, global int* outputBuffer, int numElements) {
  int gid = get_global_id(0);
  if (gid < numElements) {
    outputBuffer[hook(2, gid)] = buffer1[hook(0, gid)] + buffer2[hook(1, gid)];
  }
}