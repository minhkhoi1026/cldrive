//{"dst0":1,"dst1":3,"dst2":5,"dst3":7,"src0":0,"src1":2,"src2":4,"src3":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bswap(global unsigned int* src0, global unsigned int* dst0, global ushort* src1, global ushort* dst1, int src2, global int* dst2, short src3, global short* dst3) {
  if (get_global_id(0) % 2 == 0) {
    dst0[hook(1, get_global_id(0))] = __builtin_bswap32(src0[hook(0, get_global_id(0))]);
  } else {
    dst0[hook(1, get_global_id(0))] = src0[hook(0, get_global_id(0))];
  }

  dst1[hook(3, get_global_id(0))] = __builtin_bswap16(src1[hook(2, get_global_id(0))]);
  if (get_global_id(0) % 2 == 1) {
    dst1[hook(3, get_global_id(0))] = __builtin_bswap16(dst1[hook(3, get_global_id(0))] + 1);
  }

  dst2[hook(5, get_global_id(0))] = __builtin_bswap32(src2);
  dst3[hook(7, get_global_id(0))] = __builtin_bswap16(src3);
}