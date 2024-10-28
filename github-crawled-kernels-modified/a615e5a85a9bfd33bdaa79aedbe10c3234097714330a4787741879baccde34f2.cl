//{"input":0,"output":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blockAddition_kernel(global int* restrict input, global int* restrict output) {
  int globalId = get_global_id(0);
  int groupId = get_group_id(0);
  int localId = get_local_id(0);

  local int value[1];

  if (localId == 0) {
    value[hook(2, 0)] = input[hook(0, groupId)];
  }
  barrier(0x01);

  output[hook(1, globalId * 2)] += value[hook(2, 0)];
  output[hook(1, globalId * 2 + 1)] += value[hook(2, 0)];
}