//{"N":2,"block":3,"inArray":0,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_Decomp(const global unsigned int* inArray, global unsigned int* outArray, unsigned int N, local unsigned int* block) {
  int LID = get_local_id(0);
  int Elem = get_local_size(0) * get_group_id(0) * 2 + LID;
  int LSize = get_local_size(0);
  block[hook(3, LID)] = inArray[hook(0, Elem)] + inArray[hook(0, Elem + LSize)];
  barrier(0x01);
  for (int stride = LSize / 2; stride >= 1; stride /= 2) {
    if (LID < stride)
      block[hook(3, LID)] += block[hook(3, LID + stride)];
    barrier(0x01);
  }
  if (LID == 0)
    outArray[hook(1, get_group_id(0))] = block[hook(3, 0)];
}