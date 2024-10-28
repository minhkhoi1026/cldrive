//{"inout":0,"out":2,"second":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void selfdot_ints_withoutscratch(global int* inout, global int* second, global int* out) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);
  int workgroupSize = get_local_size(0);
  int workgroupid = get_group_id(0);

  const int workgroupOffset = workgroupid * workgroupSize;

  int sum = 0;
  int us = inout[hook(0, globalId)];
  for (int i = 0; i < workgroupSize; i++) {
    sum += inout[hook(0, workgroupOffset + i)] * us;
  }
  second[hook(1, globalId)] = sum;
  barrier(0x01);
  for (int offset = (workgroupSize >> 1); offset > 0; offset >>= 1) {
    if (localId < offset) {
      second[hook(1, globalId)] = second[hook(1, globalId)] + second[hook(1, globalId + offset)];
    }
    barrier(0x01);
  }

  if (localId == 0) {
    out[hook(2, workgroupid)] = second[hook(1, globalId)];
  }
}