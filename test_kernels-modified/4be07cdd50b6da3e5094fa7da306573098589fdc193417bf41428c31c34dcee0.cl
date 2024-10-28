//{"inout":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceViaScratch(global float* inout, local float* scratch) {
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);

  scratch[hook(1, localId)] = inout[hook(0, localId)];
  barrier(0x01);

  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      scratch[hook(1, localId)] = scratch[hook(1, localId)] + scratch[hook(1, localId + offset)];
    }
    barrier(0x01);
  }

  inout[hook(0, localId)] = scratch[hook(1, localId)];
}