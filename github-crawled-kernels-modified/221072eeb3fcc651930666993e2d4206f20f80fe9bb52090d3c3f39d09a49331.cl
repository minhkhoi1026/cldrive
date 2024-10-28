//{"dst":1,"offset":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vload_bench_10000uchar3(global uchar* src, global unsigned int* dst, unsigned int offset) {
  int id = (int)get_global_id(0);
  uint3 srcV = 0;
  for (int i = 0; i < 10000; i++) {
    srcV += convert_uint3(vload3(id + (i & 0xFFFF), src + offset));
  }
  vstore3(srcV, id, dst);
}