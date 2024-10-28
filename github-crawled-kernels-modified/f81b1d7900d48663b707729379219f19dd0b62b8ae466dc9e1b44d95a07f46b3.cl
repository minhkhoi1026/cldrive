//{"inout":0,"out":1,"scratch":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceViaScratch_multipleworkgroups_ints(global int* inout, global int* out, local int* scratch) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);
  int workgroupid = get_group_id(0);

  scratch[hook(2, localId)] = inout[hook(0, globalId)];
  barrier(0x01);
  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      scratch[hook(2, localId)] = scratch[hook(2, localId)] + scratch[hook(2, localId + offset)];
    }
    barrier(0x01);
  }

  inout[hook(0, globalId)] = scratch[hook(2, localId)];
  if (localId == 0) {
    out[hook(1, workgroupid)] = scratch[hook(2, 0)];
  }
}