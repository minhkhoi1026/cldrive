//{"arr":0,"prefixArr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int pow_two(int exp) {
  return 1 << exp;
}

kernel void baseAlgo(global int* arr, global int* prefixArr) {
  int locId = get_local_id(0);

  prefixArr[hook(1, locId * 2)] = arr[hook(0, locId * 2)];
  prefixArr[hook(1, locId * 2 + 1)] = arr[hook(0, locId * 2 + 1)];

  barrier(0x01);

  for (int d = 0; d < 7; d++) {
    int lowIndex = pow_two(d) - 1 + locId * pow_two(d + 1);
    int highIndex = pow_two(d + 1) - 1 + locId * pow_two(d + 1);
    if (highIndex < 256) {
      prefixArr[hook(1, highIndex)] = prefixArr[hook(1, lowIndex)] + prefixArr[hook(1, highIndex)];
    }

    barrier(0x01);
  }

  if (locId == 0) {
    prefixArr[hook(1, 255)] = 0;
  }
  barrier(0x01);

  for (int d = 7; d >= 0; d--) {
    int lowIndex = pow_two(d) - 1 + locId * pow_two(d + 1);
    int highIndex = pow_two(d + 1) - 1 + locId * pow_two(d + 1);
    if (highIndex < 256) {
      int t = prefixArr[hook(1, lowIndex)];
      prefixArr[hook(1, lowIndex)] = prefixArr[hook(1, highIndex)];
      prefixArr[hook(1, highIndex)] = t + prefixArr[hook(1, highIndex)];
    }
    barrier(0x01);
  }
}