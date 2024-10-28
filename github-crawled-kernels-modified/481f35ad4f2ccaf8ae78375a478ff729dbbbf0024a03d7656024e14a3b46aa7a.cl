//{"blockSums":1,"localBuffer":3,"output":0,"outputSize":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel__UniformAdd(global int* output, global const int* blockSums, const unsigned int outputSize) {
  unsigned int gid = get_global_id(0) * 2;
  const unsigned int tid = get_local_id(0);
  const unsigned int blockId = get_group_id(0);

  local int localBuffer[1];

  if (tid < 1)
    localBuffer[hook(3, 0)] = blockSums[hook(1, blockId)];

  barrier(0x01);

  if (gid < outputSize)
    output[hook(0, gid)] += localBuffer[hook(3, 0)];
  gid++;
  if (gid < outputSize)
    output[hook(0, gid)] += localBuffer[hook(3, 0)];
}