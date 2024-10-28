//{"N":1,"base":0,"period":3,"repeats":2}
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

kernel void deviceShortLCG0(global unsigned int* base, unsigned int N, unsigned int repeats, const int period) {
  int a, c;
  switch (period) {
    case 1024:
      a = 0x0fbfffff;
      c = 0x3bf75696;
      break;
    case 512:
      a = 0x61c8647f;
      c = 0x2b3e0000;
      break;
    case 256:
      a = 0x7161ac7f;
      c = 0x43840000;
      break;
    case 128:
      a = 0x0432b47f;
      c = 0x1ce80000;
      break;
    case 2048:
      a = 0x763fffff;
      c = 0x4769466f;
      break;
    default:
      a = 0;
      c = 0;
      break;
  }

  unsigned int value = 0;
  for (unsigned int rep = 0; rep < repeats; rep++) {
    (value) = ~(value);
    for (unsigned int iter = 0; iter < period; iter++) {
      (value) = ~(value);
      (value) = (a) * (value) + (c);
      (value) ^= 0xFFFFFFF0;
      (value) ^= 0xF;
    }
    (value) = ~(value);
  }

  for (unsigned int i = 0; i < N; i++) {
    *((base + get_group_id(0) * N * get_local_size(0) + i * get_local_size(0) + get_local_id(0))) = value;
  }
}