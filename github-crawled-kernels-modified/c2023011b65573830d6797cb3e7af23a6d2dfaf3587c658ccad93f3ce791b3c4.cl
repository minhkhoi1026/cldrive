//{"output":1,"sortedDeletionBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FindFirstOne(global int* sortedDeletionBuffer, global int* output) {
  const int idx = get_global_id(0);
  if (sortedDeletionBuffer[hook(0, idx)] == 1) {
    if (idx == 0 || (idx > 0 && sortedDeletionBuffer[hook(0, idx - 1)] == 0)) {
      output[hook(1, 0)] = idx;
    }
  }
}