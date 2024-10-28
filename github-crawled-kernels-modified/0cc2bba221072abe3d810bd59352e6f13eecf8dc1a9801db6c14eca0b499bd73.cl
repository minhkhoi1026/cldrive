//{"outArray":1,"srcArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate(global int* srcArray, global int* outArray) {
  int d = 100;
  int x = get_global_id(0) + 1;
  int y = get_global_id(1) + 1;
  int gid = y * (d + 2) + x;
  int neighborTotal;

  if (y <= d && x <= d) {
    int cell = srcArray[hook(0, gid)];

    switch (srcArray[hook(0, gid - (d + 1))] + srcArray[hook(0, gid - (d + 2))] + srcArray[hook(0, gid + (d + 1))] + srcArray[hook(0, gid + (d + 2))] + srcArray[hook(0, gid + 1)] + srcArray[hook(0, gid - 1)] + srcArray[hook(0, gid + (d + 3))] + srcArray[hook(0, gid - (d + 3))]) {
      case 0:
      case 1:
        outArray[hook(1, gid)] = 0;
        break;
      case 2:
        outArray[hook(1, gid)] = cell;
        break;
      case 3:
        outArray[hook(1, gid)] = 1;
        break;
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        outArray[hook(1, gid)] = 0;
        break;
    }
  }
}