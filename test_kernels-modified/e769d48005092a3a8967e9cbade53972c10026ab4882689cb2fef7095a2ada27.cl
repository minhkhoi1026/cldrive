//{"input":0,"localResult":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotReducer(global double* input, global double* output) {
  local double localResult[128];
  unsigned int localId = get_local_id(0);
  unsigned int globalID = get_global_id(0);
  unsigned int s;

  output[hook(1, globalID)] = 0.0;
  localResult[hook(2, localId)] = input[hook(0, globalID)];

  barrier(0x01);

  for (s = 128 / 2; s > 0; s >>= 1) {
    if (localId < s)
      localResult[hook(2, localId)] += localResult[hook(2, localId + s)];
    barrier(0x01);
  }

  if (localId == 0)
    output[hook(1, get_group_id(0))] = localResult[hook(2, 0)];
}