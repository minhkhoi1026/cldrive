//{"inout":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_multipleworkgroups_ints_noscratch(global int* inout, global int* out) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);
  int workgroupid = get_group_id(0);

  barrier(0x01);
  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      inout[hook(0, globalId)] = inout[hook(0, globalId)] + inout[hook(0, globalId + offset)];
    }
    barrier(0x01);
  }

  if (localId == 0) {
    out[hook(1, workgroupid)] = inout[hook(0, globalId)];
  }
}