//{"N":2,"block":3,"inArray":0,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_DecompUnroll(const global unsigned int* inArray, global unsigned int* outArray, unsigned int N, local unsigned int* block) {
  int LID = get_local_id(0);
  int Elem = get_local_size(0) * get_group_id(0) * 2 + LID;
  int LSize = get_local_size(0);
  block[hook(3, LID)] = inArray[hook(0, Elem)] + inArray[hook(0, Elem + LSize)];
  barrier(0x01);
  if (LID < 128 && LSize > 128)
    block[hook(3, LID)] += block[hook(3, LID + 128)];
  barrier(0x01);
  if (LID < 64 && LSize > 64)
    block[hook(3, LID)] += block[hook(3, LID + 64)];
  barrier(0x01);
  if (LID < 32 && LSize > 32)
    block[hook(3, LID)] += block[hook(3, LID + 32)];
  barrier(0x01);
  if (LID < 16 && LSize > 16)
    block[hook(3, LID)] += block[hook(3, LID + 16)];
  barrier(0x01);
  if (LID < 8 && LSize > 8)
    block[hook(3, LID)] += block[hook(3, LID + 8)];
  barrier(0x01);
  if (LID < 4 && LSize > 4)
    block[hook(3, LID)] += block[hook(3, LID + 4)];
  barrier(0x01);
  if (LID < 2 && LSize > 2)
    block[hook(3, LID)] += block[hook(3, LID + 2)];
  barrier(0x01);
  if (LID < 1)
    outArray[hook(1, get_group_id(0))] = block[hook(3, LID)] + block[hook(3, LID + 1)];
}