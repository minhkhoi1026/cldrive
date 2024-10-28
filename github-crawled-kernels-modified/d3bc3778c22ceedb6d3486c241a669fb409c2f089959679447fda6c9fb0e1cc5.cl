//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_switch(global int* dst, global int* src) {
  switch (get_global_id(0)) {
    case 0:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 4)];
      break;
    case 1:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 14)];
      break;
    case 2:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 13)];
      break;
    case 6:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 11)];
      break;
    case 7:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 10)];
      break;
    case 10:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 9)];
      break;
    case 12:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 6)];
      break;
    default:
      dst[hook(0, get_global_id(0))] = src[hook(1, get_global_id(0) + 8)];
      break;
  }
}