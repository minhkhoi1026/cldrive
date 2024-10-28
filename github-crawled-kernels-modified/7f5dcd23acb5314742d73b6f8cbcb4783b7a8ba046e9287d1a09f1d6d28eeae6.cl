//{"N":1,"base":0,"blockErrorCount":3,"konstant":2,"threadErrorCount":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned __popc(unsigned int x) {
  if (x == 0)
    return 0;
  if ((x &= x - 1) == 0)
    return 1;
  if ((x &= x - 1) == 0)
    return 2;
  if ((x &= x - 1) == 0)
    return 3;
  if ((x &= x - 1) == 0)
    return 4;
  if ((x &= x - 1) == 0)
    return 5;
  if ((x &= x - 1) == 0)
    return 6;
  if ((x &= x - 1) == 0)
    return 7;
  if ((x &= x - 1) == 0)
    return 8;
  if ((x &= x - 1) == 0)
    return 9;
  if ((x &= x - 1) == 0)
    return 10;
  if ((x &= x - 1) == 0)
    return 11;
  if ((x &= x - 1) == 0)
    return 12;
  if ((x &= x - 1) == 0)
    return 13;
  if ((x &= x - 1) == 0)
    return 14;
  if ((x &= x - 1) == 0)
    return 15;
  if ((x &= x - 1) == 0)
    return 16;
  if ((x &= x - 1) == 0)
    return 17;
  if ((x &= x - 1) == 0)
    return 18;
  if ((x &= x - 1) == 0)
    return 19;
  if ((x &= x - 1) == 0)
    return 20;
  if ((x &= x - 1) == 0)
    return 21;
  if ((x &= x - 1) == 0)
    return 22;
  if ((x &= x - 1) == 0)
    return 23;
  if ((x &= x - 1) == 0)
    return 24;
  if ((x &= x - 1) == 0)
    return 25;
  if ((x &= x - 1) == 0)
    return 26;
  if ((x &= x - 1) == 0)
    return 27;
  if ((x &= x - 1) == 0)
    return 28;
  if ((x &= x - 1) == 0)
    return 29;
  if ((x &= x - 1) == 0)
    return 30;
  if ((x &= x - 1) == 0)
    return 31;
  return 32;
}

kernel void deviceVerifyConstant(global unsigned int* base, unsigned int N, const unsigned int konstant, global unsigned int* blockErrorCount, local unsigned int* threadErrorCount) {
  threadErrorCount[hook(4, get_local_id(0))] = 0;

  for (unsigned int i = 0; i < N; i++) {
    threadErrorCount[hook(4, get_local_id(0))] += __popc((*((base + get_group_id(0) * N * get_local_size(0) + i * get_local_size(0) + get_local_id(0)))) ^ (konstant));
  }

  for (unsigned int stride = get_local_size(0) >> 1; stride > 0; stride >>= 1) {
    barrier(0x01);
    if (get_local_id(0) < stride)
      threadErrorCount[hook(4, get_local_id(0))] += threadErrorCount[hook(4, get_local_id(0) + stride)];
  }
  barrier(0x01);

  if (get_local_id(0) == 0)
    blockErrorCount[hook(3, get_group_id(0))] = threadErrorCount[hook(4, 0)];

  return;
}