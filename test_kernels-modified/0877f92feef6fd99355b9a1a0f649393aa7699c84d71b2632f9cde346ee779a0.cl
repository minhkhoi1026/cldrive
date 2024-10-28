//{"inout":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceGlobal(global float* inout) {
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);

  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      inout[hook(0, localId)] = inout[hook(0, localId)] + inout[hook(0, localId + offset)];
    }
    barrier(0x01);
  }
}