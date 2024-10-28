//{"binResult":2,"data":0,"input":3,"sharedArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram256(global const uint4* data, local uchar* sharedArray, global unsigned int* binResult) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);

  int offSet1 = localId & 31;
  int offSet2 = 4 * offSet1;
  int bankNumber = localId >> 5;

  local uchar4* input = (local uchar4*)sharedArray;
  for (int i = 0; i < 64; ++i)
    input[hook(3, groupSize * i + localId)] = 0;

  barrier(0x01);

  for (int i = 0; i < 64; i++) {
    uint4 value = data[hook(0, groupId * groupSize * 256 / 4 + i * groupSize + localId)];
    sharedArray[hook(1, value.s0 * 128 + offSet2 + bankNumber)]++;
    sharedArray[hook(1, value.s1 * 128 + offSet2 + bankNumber)]++;
    sharedArray[hook(1, value.s2 * 128 + offSet2 + bankNumber)]++;
    sharedArray[hook(1, value.s3 * 128 + offSet2 + bankNumber)]++;
  }
  barrier(0x01);

  if (localId == 0) {
    for (int i = 0; i < 256; ++i) {
      unsigned int result = 0;
      for (int j = 0; j < 128; ++j) {
        result += sharedArray[hook(1, i * 128 + j)];
      }
      binResult[hook(2, groupId * 256 + i)] = result;
    }
  }
}