//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_2(global long* src1, global long* src2, global long* dst) {
  int i = get_global_id(0);
  switch (i) {
    case 0:
      dst[hook(2, i)] = 0xFEDCBA9876543210UL;
      break;
    case 1:
      dst[hook(2, i)] = src1[hook(0, i)] & src2[hook(1, i)];
      break;
    case 2:
      dst[hook(2, i)] = src1[hook(0, i)] | src2[hook(1, i)];
      break;
    case 3:
      dst[hook(2, i)] = src1[hook(0, i)] ^ src2[hook(1, i)];
      break;
    case 4:
      dst[hook(2, i)] = src1[hook(0, i)] ? 0x1122334455667788L : 0x8877665544332211UL;
      break;
  }
}