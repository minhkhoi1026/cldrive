//{"in":0,"out":1,"scratch1":2,"scratch2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void selfdot_ints_withscratch(global int* in, global int* out, local int* scratch1, local int* scratch2) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);
  int workgroupid = get_group_id(0);

  scratch1[hook(2, localId)] = in[hook(0, globalId)];
  barrier(0x01);
  int sum = 0;
  int us = scratch1[hook(2, localId)];
  for (int i = 0; i < workgroupSize; i++) {
    sum += us * scratch1[hook(2, i)];
  }
  scratch2[hook(3, localId)] = sum;
  barrier(0x01);
  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      scratch2[hook(3, localId)] = scratch2[hook(3, localId)] + scratch2[hook(3, localId + offset)];
    }
    barrier(0x01);
  }

  if (localId == 0) {
    out[hook(1, workgroupid)] = scratch2[hook(3, 0)];
  }
}