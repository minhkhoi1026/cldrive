//{"binResult":2,"data":0,"input":3,"sharedArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram256_1threadPerBlock(global const unsigned int* data, local unsigned int* sharedArray, global unsigned int* binResult) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);
  size_t numOfGroups = get_num_groups(0);

  local unsigned int* input = (local unsigned int*)sharedArray;

  for (int i = 0; i < 256; ++i)
    input[hook(3, i)] = 0;

  barrier(0x01);

  for (int i = 0; i < 256; ++i)
    input[hook(3, data[ihook(0, i))]++;

  barrier(0x01);

  if (localId == 0)
    for (int i = 0; i < 256; ++i) {
      unsigned int t = input[hook(3, i)];
      atomic_add(binResult + i, t);
    }
}